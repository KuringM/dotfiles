import re
import requests

ANKI_CONNECT_URL = "http://localhost:8765"
FIELD_NAME = "Front"  # 修改为你要处理的字段名


def invoke(action, **params):
    response = requests.post(
        ANKI_CONNECT_URL, json={"action": action, "version": 6, "params": params}
    )
    return response.json()


# ✅ 格式化函数（你可以扩展）
def format_field(text):
    # 1. 删除 <h2> 标签
    text = re.sub(r"<h2[^>]*>", "", text, flags=re.IGNORECASE)
    text = re.sub(r"</h2>", "", text, flags=re.IGNORECASE)

    # 2. 处理问号：
    # 保留原公式区块，替换内部 ? 为 \text{__}，外部为 \(\text{__}\)
    math_spans = []
    for m in re.finditer(r"\\\((.*?)\\\)", text, flags=re.DOTALL):
        math_spans.append((m.start(), m.end(), m.group(0)))
    for m in re.finditer(r"\\\[(.*?)\\\]", text, flags=re.DOTALL):
        math_spans.append((m.start(), m.end(), m.group(0)))
    math_spans.sort()

    result = ""
    last_index = 0
    for start, end, content in math_spans:
        outside = text[last_index:start].replace("?", r"\(\text{__}\)")
        inside = content.replace("?", r"\text{__}")
        result += outside + inside
        last_index = end
    result += text[last_index:].replace("?", r"\(\text{__}\)")

    text = result

    # 3. 去除多余空行、两边空格
    text = re.sub(r"\s*\n\s*", "\n", text).strip()

    # 4. 可选包裹为 div
    # text = f'<div class="formatted">{text}</div>'

    return text


# ✅ 格式化函数：提取 <h1>~<h6> 内容并拼接为一行
def extract_headers(text):
    headers = re.findall(
        r"<h[1-6][^>]*>(.*?)</h[1-6]>", text, flags=re.DOTALL | re.IGNORECASE
    )
    header_line = " ".join(h.strip().replace("\n", " ") for h in headers)
    return header_line.strip()


def main():
    print("📦 正在批量格式化 Anki 字段...")
    note_ids = invoke("findNotes", query="deck:*")["result"]
    print(f"共找到 {len(note_ids)} 条笔记")

    notes_info = invoke("notesInfo", notes=note_ids)["result"]
    updated = 0

    for note in notes_info:
        fields = note.get("fields", {})
        if FIELD_NAME not in fields:
            continue

        original = fields[FIELD_NAME]["value"]
        formatted = format_field(original)
        extracted = extract_headers(original)

        if original != formatted:
            invoke(
                "updateNoteFields",
                note={"id": note["noteId"], "fields": {FIELD_NAME: formatted}},
            )
            print(f"✅ 已更新笔记 {note['noteId']}")
            updated += 1

    print(f"🎉 批量格式化完成，共更新 {updated} 条笔记")


if __name__ == "__main__":
    main()
