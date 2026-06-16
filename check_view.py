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

# Check existing views
views = find_all(root, "View")
print(f"Views in PDM: {len(views)}")
for v in views:
    name = ""
    for c in v:
        tag = c.tag.split("}")[-1] if "}" in c.tag else c.tag
        if tag == "Name":
            name = c.text or ""
    print(f"  View: {name}")
