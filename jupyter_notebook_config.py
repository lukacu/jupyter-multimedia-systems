import os

c.NotebookApp.token=os.getenv("JPY_API_TOKEN", "")
c.NotebookApp.password=''
c.NotebookApp.terminals_enabled = False
c.NotebookApp.notebook_dir = "/home/jovyan/work"
