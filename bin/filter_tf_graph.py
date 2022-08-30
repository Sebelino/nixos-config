#!/usr/bin/env python3

import fileinput

if __name__ == "__main__":
    for line in fileinput.input():
        blacklisted_strings = {
            "registry.terraform.io/integrations/github",
            "registry.terraform.io/hashicorp/aws",
        }
        if any(bls in line for bls in blacklisted_strings):
            continue
        print(line, end="")
