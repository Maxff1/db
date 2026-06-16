import xml.etree.ElementTree as ET

with open(r"C:\Users\DELL\Desktop\数据库实训\db\改进的物理模型.pdm", "r", encoding="utf-8") as f:
    content = f.read()

root = ET.fromstring(content)

def find_all(elem, target):
    result = []
    for child in elem:
        tag = child.tag.split("}")[-1] if "}" in child.tag else child.tag
        if tag == target:
            result.append(child)
        result.extend(find_all(child, target))
    return result

# Check for triggers
triggers = find_all(root, "Trigger")
print(f"Triggers found in PDM: {len(triggers)}")
for trg in triggers:
    name = ""
    code = ""
    for c in trg:
        tag = c.tag.split("}")[-1] if "}" in c.tag else c.tag
        if tag == "Name":
            name = c.text or ""
        elif tag == "Code":
            code = c.text or ""
    print(f"  Trigger: {name} ({code})")

# Check all tables again, but this time look for triggers per table
tables = []
for child in root.iter():
    tag = child.tag.split("}")[-1] if "}" in child.tag else child.tag
    if tag == "Tables":
        for c in child:
            tables.append(c)

print(f"\nTables: {len(tables)}")
for tbl in tables:
    tname = ""
    for c in tbl:
        tag = c.tag.split("}")[-1] if "}" in c.tag else c.tag
        if tag == "Name":
            tname = c.text or ""
        elif tag == "Triggers":
            trg_count = len(list(c))
            print(f"  {tname}: {trg_count} triggers")
