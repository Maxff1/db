import xml.etree.ElementTree as ET

with open(r"C:\Users\DELL\Desktop\数据库实训\db\改进的物理模型.pdm", "r", encoding="utf-8") as f:
    content = f.read()

root = ET.fromstring(content)

def find_all(elem, tag_name):
    result = []
    for child in elem:
        tag = child.tag.split("}")[-1] if "}" in child.tag else child.tag
        if tag == tag_name:
            result.append(child)
        result.extend(find_all(child, tag_name))
    return result

# Detailed look at key tables
tables = find_all(root, "Table")
for tbl in tables:
    name = ""
    columns = []
    for child in tbl:
        tag = child.tag.split("}")[-1] if "}" in child.tag else child.tag
        if tag == "Name":
            name = child.text or ""
        elif tag == "Columns":
            for col in child:
                col_info = {}
                for c2 in col:
                    t2 = c2.tag.split("}")[-1] if "}" in c2.tag else c2.tag
                    if t2 in ("Name", "Code", "DataType", "Length", "Column.Mandatory"):
                        col_info[t2] = c2.text or ""
                columns.append(col_info)
    print(f"\n【{name}】")
    for c in columns:
        mand = "NOT NULL" if c.get("Column.Mandatory") == "1" else "NULL"
        print(f"  {c.get('Name','?')}: {c.get('DataType','?')}({c.get('Length','?')}) {mand}")
