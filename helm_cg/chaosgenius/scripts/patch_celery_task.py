import os
code = """

import functools

def track_task(func):
    @functools.wraps(func)
    def wraps(*args, **kwargs):
        incr_current()
        res = func(*args, **kwargs)
        incr_current(-1)
        return res
    return wraps


def incr_current(by_num=1):
    try:
        from pathlib import Path
        fle = Path('/tmp/.current')
        fle.touch(exist_ok=True)
        with open('/tmp/.current', "r+") as s:
            try:
                curr_no =  int(s.read()) + by_num
            except Exception as e:
                curr_no = 1
            finally:
                s.seek(0)
                s.write(str(max(curr_no, 0)))
                s.truncate()
    except Exception as e:
        print(e)
"""

root_dir = "/usr/src/app/"


utils_path = "chaos_genius/utils/utils.py"

with open(root_dir+utils_path, "r") as utils_file:
    utils_file_content = utils_file.read()

with open(root_dir+utils_path, "a") as utils_file:
    if code not in utils_file_content:
        # pass
        utils_file.write(code)


import_line = "from chaos_genius.utils.utils import track_task"


celery_jobs_dir = "chaos_genius/jobs/"


import pathlib

jobs_files = list(pathlib.Path(root_dir+celery_jobs_dir).glob('*.py'))

replacement_decorators = """@celery.task
@track_task"""

print(jobs_files)
# jobs_files = []
for job_file in jobs_files:
    with open(job_file, 'r') as f:
        job_file_content = f.read()
    
    if "@celery.task" in job_file_content and import_line not in job_file_content:
        job_file_content = import_line + "\n" + job_file_content
        job_file_content = job_file_content.replace("@celery.task", replacement_decorators)

        with open(job_file, "w") as f:
            f.write(job_file_content)

