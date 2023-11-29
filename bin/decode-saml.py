#!/usr/bin/env python3

import sys
import base64
import zlib
import xml.dom.minidom

inp = sys.stdin.read()
decoded = base64.b64decode(inp)
inflated = zlib.decompress(decoded, -zlib.MAX_WBITS).decode()
prettified = xml.dom.minidom.parseString(inflated)
print(prettified.toprettyxml())
