import json
import subprocess

import matplotlib.pyplot as plt
from pygit2 import Repository
from pygit2.enums import SortMode


def main():
    repo = Repository(".git")
    # preserved_head = repo.head.name
    # print(f"preserving target at {preserved_head}")

    plot_dicts = []

    for commit in repo.walk(repo.head.target, SortMode.TOPOLOGICAL | SortMode.REVERSE):
        print(f"checking {commit.short_id}")
        process = subprocess.Popen(
            ["cloc", "--git", str(commit.id), "--json"],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
        )
        out, _ = process.communicate()
        stats = json.loads(out)
        del stats["header"]
        plot_dicts.append(stats)

    x_points = list(range(0, len(plot_dicts)))

    fig, ax = plt.subplots()
    lang_set = set()
    for dict_ in plot_dicts:
        for lang in dict_:
            lang_set.add(lang)
    print(lang_set)

    for lang in lang_set:
        ax.plot(
            x_points,
            list(map(lambda x: x.get(lang, {"code": 0})["code"], plot_dicts)),
            label=lang,
        )

    plt.legend()

    plt.show()
