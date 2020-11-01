#!/usr/bin/env python3

r"""
Untangles JSON embedded in strings recursively and beautifies it.

For example,

f("{\"hoy\": \"{\\\"joy\\\": \\\"{}\\\"}\"}")
{"hoy": f("{\"joy\": \"{}\"}")}
{"hoy": {"joy": f("{}")}}
{"hoy": {"joy": {}}}

becomes

{
  "hoy": {
    "joy": "{}"
  }
}
"""

import json

def untangle_list(jsonlist: list) -> dict:
    for i in range(len(jsonlist)):
        if isinstance(jsonlist[i], str):
            jsonlist[i] = untangle_string(jsonlist[i])
        elif isinstance(jsonlist[i], dict):
            jsonlist[i] = untangle_dict(jsonlist[i])
        elif isinstance(jsonlist[i], list):
            jsonlist[i] = untangle_list(jsonlist[i])
    return jsonlist

def untangle_dict(jsondict: dict) -> dict:
    for k, v in jsondict.items():
        if isinstance(v, str):
            jsondict[k] = untangle_string(v)
        elif isinstance(v, dict):
            jsondict[k] = untangle_dict(v)
        elif isinstance(v, list):
            jsondict[k] = untangle_list(v)
    return jsondict

def untangle_string(jsonstring: str):
    try:
        jsonobject = json.loads(jsonstring)
    except json.decoder.JSONDecodeError:
        return jsonstring
    if isinstance(jsonobject, str):
        return untangle_string(jsonobject)
    elif isinstance(jsonobject, dict):
        return untangle_dict(jsonobject)
    elif isinstance(jsonobject, list):
        return untangle_list(jsonobject)
    return jsonobject

if __name__ == '__main__':
    stdin = input()

    jsonobject = untangle_string(stdin)

    print(json.dumps(jsonobject, indent=4, sort_keys=True), end="")
