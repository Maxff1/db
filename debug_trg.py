import xml.etree.ElementTree as ET

with open(r"C:\Users\DELL\Desktop\数据库实训\db\改进的物理模型.pdm", "r", encoding="utf-8") as f:
    content = f.read()

root = ET.fromstring(content)

# Find first trigger and print its full structure
def find_all(elem, target):
    result = []
    for child in elem:
        tag = child.tag.split("}")[-1] if "}" in child.tag else child.tag
        if tag == target:
            result.append(child)
        result.extend(find_all(child, target))
    return result

triggers = find_all(root, "Trigger")
if triggers:
    # Print structure of first trigger
    def print_tree(elem, indent=0):
        tag = elem.tag.split("}")[-1] if "}" in elem.tag else elem.tag
        text = (elem.text or "").strip()
        attrs = dict(elem.attrib)
        attr_str = ""
        if attrs:
            attr_str = " " + str(attrs)
        line = "  " * indent + f"<{tag}{attr_str}>"
        if text:
            line += f" {text[:60]}"
        print(line)
        for child in elem:
            print_tree(child, indent + 1)
    
    print("=== First Trigger Structure ===")
    print_tree(triggers[0])
    print("\n=== Second Trigger Structure ===")
    print_tree(triggers[1])
