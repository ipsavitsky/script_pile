import matplotlib
import subprocess
import json
from pygit2 import Repository
from pygit2.enums import SortMode

repo = Repository(".git")
preserved_head = repo.head.target
print(f"preserving target at {preserved_head}")

for commit in repo.walk(repo.head.target, SortMode.TOPOLOGICAL | SortMode.REVERSE):
    print(f"checking out {commit.short_id}")
    repo.set_head(commit.id)
    repo.checkout()
    process = subprocess.Popen(['cloc', '--vcs=git', '--json'],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE)
    out, _ = process.communicate()
    stats = json.loads(out)
    print(stats)
