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

# Build column id -> name mapping first
col_map = {}
tables = find_all(root, "Table")
for tbl in tables:
    for c in tbl:
        tag = c.tag.split("}")[-1] if "}" in c.tag else c.tag
        if tag == "Columns":
            for col in c:
                col_name = ""
                col_id = ""
                for c2 in col:
                    t2 = c2.tag.split("}")[-1] if "}" in c2.tag else c2.tag
                    if t2 == "Name":
                        col_name = c2.text or ""
                    elif t2 == "ObjectID":
                        col_id = c2.text or ""
                col_map[col_id] = col_name

# Print tables with keys
for tbl in tables:
    tname = ""
    for c in tbl:
        tag = c.tag.split("}")[-1] if "}" in c.tag else c.tag
        if tag == "Name":
            tname = c.text or ""

    if tname in ("用户", "队伍", "报名人", "裁判执行赛程", "队伍关系成员操作", "报名项目"):
        keys_output = []
        for c in tbl:
            tag = c.tag.split("}")[-1] if "}" in c.tag else c.tag
            if tag == "Keys":
                for key in c:
                    kname = ""
                    kcols = []
                    for kc in key:
                        kt = kc.tag.split("}")[-1] if "}" in kc.tag else kc.tag
                        if kt == "Name":
                            kname = kc.text or ""
                        elif kt == "Key.Columns":
                            for kcol in kc:
                                ref = kcol.get("Ref", "")
                                kcols.append(col_map.get(ref, ref))
                    keys_output.append(f"{kname}: ({', '.join(kcols)})")
        print(f"【{tname}】主键: {'; '.join(keys_output)}")

# Print references related to 用户 and 队伍
refs = find_all(root, "Reference")
print("\n--- 涉及到用户/队伍的Reference Join ---")
for ref in refs:
    rname = ""
    parent_ref = ""
    child_ref = ""
    joins = []
    for rc in ref:
        rt = rc.tag.split("}")[-1] if "}" in rc.tag else rc.tag
        if rt == "Name":
            rname = rc.text or ""
        elif rt == "ParentTable":
            for o in rc:
                parent_ref = o.get("Ref", "")
        elif rt == "ChildTable":
            for o in rc:
                child_ref = o.get("Ref", "")
        elif rt == "Joins":
            for join in rc:
                p_col = ""
                c_col = ""
                for jc in join:
                    jt = jc.tag.split("}")[-1] if "}" in jc.tag else jc.tag
                    if jt == "Object1":
                        for o in jc:
                            p_col = col_map.get(o.get("Ref", ""), o.get("Ref", ""))
                    elif jt == "Object2":
                        for o in jc:
                            c_col = col_map.get(o.get("Ref", ""), o.get("Ref", ""))
                joins.append((p_col, c_col))

    print(f"\n{rname}")
    print(f"  父表Ref={parent_ref} 子表Ref={child_ref}")
    for i, (pc, cc) in enumerate(joins):
        print(f"  行{i+1}: {pc} -> {cc}")
