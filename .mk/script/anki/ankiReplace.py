import re
import requests

ANKI_CONNECT_URL = "http://localhost:8765"
FIELD_NAME = "Front"  # ⬅️ 修改为你实际要处理的字段名（如 "Back"）

def invoke(action, **params):
    response = requests.post(ANKI_CONNECT_URL, json={
        "action": action,
        "version": 6,
        "params": params
    })
    return response.json()

def replace_questions(text):
    math_spans = []

    # 找出所有 \( ... \) 和 \[ ... \] 范围，保存位置
    for m in re.finditer(r'\\\((.*?)\\\)', text, flags=re.DOTALL):
        math_spans.append((m.start(), m.end(), m.group(0)))
    for m in re.finditer(r'\\\[(.*?)\\\]', text, flags=re.DOTALL):
        math_spans.append((m.start(), m.end(), m.group(0)))

    # 按位置排序，避免重叠错误
    math_spans.sort()

    result = ""
    last_index = 0

    for start, end, content in math_spans:
        # 处理 math 表达式前的内容
        outside = text[last_index:start]
        outside = outside.replace('?', r'\(\text{__}\)')
        result += outside

        # 处理 math 表达式中的 ?
        inner = content.replace('?', r'\text{__}')
        result += inner

        last_index = end

    # 处理最后部分
    remaining = text[last_index:]
    remaining = remaining.replace('?', r'\(\text{__}\)')
    result += remaining

    return result

def main():
    print("🔍 正在查找所有笔记...")
    result = invoke("findNotes", query="deck:*")
    note_ids = result.get("result", [])
    print(f"📋 共找到 {len(note_ids)} 条笔记")

    if not note_ids:
        return

    notes_info = invoke("notesInfo", notes=note_ids).get("result", [])
    updated = 0

    for note in notes_info:
        fields = note.get("fields", {})
        if FIELD_NAME not in fields:
            continue
        original = fields[FIELD_NAME]["value"]
        updated_text = replace_questions(original)

        if updated_text != original:
            print(f"✅ 更新笔记 ID {note['noteId']}")
            invoke("updateNoteFields", note={
                "id": note["noteId"],
                "fields": {FIELD_NAME: updated_text}
            })
            updated += 1

    print(f"🎉 替换完成：共更新 {updated} 条笔记")

if __name__ == "__main__":
    main()
