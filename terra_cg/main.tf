data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.12.0"

  name                 = "${local.name_prefix}-vpc"
  cidr                 = var.vpc_cidr_block
  azs                  = slice(data.aws_availability_zones.available.names, 0, (var.vpc_subnet_count))
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets       = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-vpc"
  })
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "18.7.2"

  cluster_name    = local.name_prefix
  cluster_version = "1.21"
  subnet_ids      = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  # IPV6
  #   cluster_ip_family = "ipv6"

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
    # instance_types         = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
    # vpc_security_group_ids = [aws_security_group.additional.id]
  }

  eks_managed_node_groups = {
    first = {
      min_size     = 1
      max_size     = 2
      desired_size = 1

      instance_types = [var.instance_type]
      capacity_type  = "SPOT"
      labels = {
        GithubRepo = "terraform-aws-eks"
        GithubOrg  = "terraform-aws-modules"
      }
      # taints = {
      #   dedicated = {
      #     key    = "dedicated"
      #     value  = "gpuGroup"
      #     effect = "NO_SCHEDULE"
      #   }
      # }

      # update_config = {
      #   max_unavailable_percentage = 50 # or set `max_unavailable`
      # }

      tags = merge(local.common_tags, {
        Name        = "${local.name_prefix}-managed-nodegroup",
        Environment = "dev"
      })
    }
  }




  cluster_tags = local.common_tags
}

data "aws_eks_cluster_auth" "this" {
  name = module.eks.cluster_id
}

locals {
  kubeconfig = yamlencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = "terraform"
    clusters = [{
      name = module.eks.cluster_id
      cluster = {
        certificate-authority-data = module.eks.cluster_certificate_authority_data
        server                     = module.eks.cluster_endpoint
      }
    }]
    contexts = [{
      name = "terraform"
      context = {
        cluster = module.eks.cluster_id
        user    = "terraform"
      }
    }]
    users = [{
      name = "terraform"
      user = {
        token = data.aws_eks_cluster_auth.this.token
      }
    }]
  })
}

resource "null_resource" "patch" {
  triggers = {
    kubeconfig = base64encode(local.kubeconfig)
    cmd_patch  = "kubectl patch configmap/aws-auth --patch \"${module.eks.aws_auth_configmap_yaml}\" -n kube-system --kubeconfig <(echo $KUBECONFIG | base64 --decode)"
  }

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    environment = {
      KUBECONFIG = self.triggers.kubeconfig
    }
    command = self.triggers.cmd_patch
  }
}
