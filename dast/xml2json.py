#!/usr/bin/env python3
import sys
import json
import xmltodict

f = open(sys.argv[1], "r")
xml_content = f.read()
f.close()
data = json.dumps(xmltodict.parse(xml_content), indent=2, sort_keys=True)
g = open(sys.argv[2], "w")
g.write(data)
g.close()
