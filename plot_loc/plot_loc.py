import matplotlib.pyplot as plt
import subprocess
import json
from pygit2 import Repository
from pygit2.enums import SortMode, CheckoutStrategy

repo = Repository(".git")
preserved_head = repo.head.name
print(f"preserving target at {preserved_head}")

plot_dicts = []

for commit in repo.walk(repo.head.target, SortMode.TOPOLOGICAL | SortMode.REVERSE):
    print(f"checking out {commit.short_id}")
    repo.set_head(commit.id)
    repo.checkout(strategy=CheckoutStrategy.SAFE | CheckoutStrategy.ALLOW_CONFLICTS)
    process = subprocess.Popen(['cloc', '--vcs=git', '--json'],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE)
    out, _ = process.communicate()
    stats = json.loads(out)
    del stats["header"]
    plot_dicts.append(stats)

print(f"plots: {plot_dicts}")
print(f"checkoutback to {preserved_head}")

x_points = list(range(0, len(plot_dicts)))

fig, ax = plt.subplots()

ax.plot(x_points, list(map(lambda x: x['SUM']['code'], plot_dicts)))

plt.show()
