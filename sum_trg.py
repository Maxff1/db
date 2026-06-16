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

# Get tables
tables = {}
for child in root.iter():
    tag = child.tag.split("}")[-1] if "}" in child.tag else child.tag
    if tag == "Tables":
        for tbl in child:
            tname = ""
            tid = ""
            for c in tbl:
                ct = c.tag.split("}")[-1] if "}" in c.tag else c.tag
                if ct == "Name":
                    tname = c.text or ""
                elif ct == "ObjectID":
                    tid = c.text or ""
            tables[tid] = tname

# Get triggers
triggers = find_all(root, "Trigger")
print(f"=== 模型中共有 {len(triggers)} 个触发器 ===\n")

count = 0
for trg in triggers:
    count += 1
    name = ""
    code = ""
    table_ref = ""
    events = []
    body = ""
    for c in trg:
        tag = c.tag.split("}")[-1] if "}" in c.tag else c.tag
        if tag == "Name":
            name = c.text or ""
        elif tag == "Code":
            code = c.text or ""
        elif tag == "Table":
            for o in c:
                table_ref = o.get("Ref", "")
        elif tag == "TriggerEvents":
            for ev in c:
                evt = ev.text or ""
                events.append(evt)
        elif tag == "TriggerBody":
            body = c.text or ""

    tbl_name = tables.get(table_ref, table_ref)
    evt_str = "/".join(events)
    print(f"{count}. {name}")
    print(f"  表: {tbl_name}  |  事件: {evt_str}")
    # Print first 80 chars of body as summary
    body_short = body[:80].replace('\n', ' ').strip()
    if body_short:
        print(f"  摘要: {body_short}...")
    print()
