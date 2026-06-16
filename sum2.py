import xml.etree.ElementTree as ET

with open(r"C:\Users\DELL\Desktop\数据库实训\db\改进的物理模型.pdm", "r", encoding="utf-8") as f:
    content = f.read()

root = ET.fromstring(content)

# Build table registry
tables = {}
def find_all(elem, target):
    result = []
    for child in elem:
        tag = child.tag.split("}")[-1] if "}" in child.tag else child.tag
        if tag == target:
            result.append(child)
        result.extend(find_all(child, target))
    return result

# Walk all tables and their triggers
table_elems = find_all(root, "Table")
for tbl in table_elems:
    tname = ""
    for c in tbl:
        tag = c.tag.split("}")[-1] if "}" in c.tag else c.tag
        if tag == "Name":
            tname = c.text or ""

    for c in tbl:
        tag = c.tag.split("}")[-1] if "}" in c.tag else c.tag
        if tag == "Triggers":
            for trg in c:
                trg_name = ""
                trg_time = ""
                trg_event = ""
                trg_order = ""
                for tc in trg:
                    tt = tc.tag.split("}")[-1] if "}" in tc.tag else tc.tag
                    if tt == "Name":
                        trg_name = tc.text or ""
                    elif tt == "Time":
                        trg_time = tc.text or ""
                    elif tt == "Event":
                        trg_event = tc.text or ""
                    elif tt == "Order":
                        trg_order = tc.text or ""
                order_str = f" #{trg_order}" if trg_order else ""
                print(f"  {trg_name}  →  {tname}  |  {trg_time.upper()} {trg_event.upper()}{order_str}")
