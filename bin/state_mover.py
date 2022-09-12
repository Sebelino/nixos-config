#!/usr/bin/env python3

import sys
import difflib


def strip_line(line):
    if line[:4] != "  # ":
        raise Exception
    line = line[4:]
    line = line.split()[0]
    return line

def similarity(string1, string2):
    seq = difflib.SequenceMatcher(a=string1, b=string2)
    return seq.ratio()

def pair_by_score(scores):
    pairs_dict = dict()
    for (c, d), v in scores.items():
        if c not in pairs_dict:
            pairs_dict[c] = (0.0, d)
        current_max, _ = pairs_dict[c]
        if v > current_max:
            pairs_dict[c] = (v, d)
    return pairs_dict

def pair_up_lines(creations, destructions):
    scores = {(c, d): similarity(c, d) for d in destructions for c in creations}
    pairs_dict = pair_by_score(scores)
    pairs = {(c, d) for (c, (v, d)) in pairs_dict.items()}
    return pairs

def to_line(pair):
    creation, destruction = pair
    return f"""
terraform state mv \\
    '{destruction}' \\
    '{creation}'
    """.strip()

if __name__ == "__main__":
    output = sys.stdin.read()
    lines = output.split("\n")
    creations = {strip_line(line) for line in lines if " will be created" in line}
    destructions = {strip_line(line) for line in lines if " will be destroyed" in line or " has been deleted" in line}
    pairs = pair_up_lines(creations, destructions)
    state_mv_lines = {to_line(pair) for pair in pairs}
    output = """
#!/usr/bin/env bash
set -euo pipefail

""".lstrip() + "\n".join(state_mv_lines)
    print(output)
