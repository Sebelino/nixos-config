#!/usr/bin/env python3

import json

if __name__ == '__main__':
    stdin = input()
    print(json.dumps(json.loads(json.loads(stdin)), ensure_ascii=False), end="")
