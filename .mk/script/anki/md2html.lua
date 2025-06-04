-- mdt2html.lua
-- 用法: lua md2html.lua 输入.md
local input_file = arg[1]
if not input_file then
	print("用法: lua md_to_html.lua 文件.md")
	os.exit(1)
end

-- 读取 Markdown 文件内容
local f = io.open(input_file, "r")
if not f then
	print("❌ 无法读取文件: " .. input_file)
	os.exit(1)
end

local lines = {}
for line in f:lines() do
	table.insert(lines, line)
end
f:close()

-------------------------------------------------------------
-- 公共工具函数
-------------------------------------------------------------

-- HTML 转义
local function escape_html(str)
	return str:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
end

-- 将 Markdown 中的数学公式转换为 MathJax 格式
local function convert_inline_tex(text)
	-- 保证是字符串
	if not text or text == "" then
		return ""
	end

	-- 转换 $$...$$ 为 \[...\]
	-- 注意必须先转换 $$ 再处理 $，否则会嵌套错
	text = text:gsub("%$%$(.-)%$%$", function(content)
		return "\\[" .. content .. "\\]"
	end)

	-- 转换行内公式 $...$ 为 \(...\)，包括行首情况
	text = text:gsub("()%$(.-)%$", function(pos, content)
		-- 避免匹配含 $ 的内容（防止 $$ 嵌套或错误）
		if content:find("%$") then
			return "$" .. content .. "$"
		else
			return "\\(" .. content .. "\\)"
		end
	end)

	return text
end

-- 加粗、斜体、链接、图片、脚注引用
local function format_inline(text)
	text = text:gsub("%*%*(.-)%*%*", "<strong>%1</strong>")
	text = text:gsub("%*(.-)%*", "<em>%1</em>")
	text = text:gsub("%[([^%]]-)%]%(([^%)]+)%)", '<a href="%2">%1</a>')
	text = text:gsub("!%[([^%]]-)%]%(([^%)]+)%)", '<img src="%2" alt="%1" />')
	text = text:gsub("%[%^([%w%d%-_]+)%]", '<sup id="ref-%1"><a href="#footnote-%1">[%1]</a></sup>')
	return convert_inline_tex(text)
end

-------------------------------------------------------------
-- 各模块处理函数
-------------------------------------------------------------

-- 标题处理
local function parse_header(line)
	local level, content = line:match("^(#+)%s*(.*)")
	if level then
		local n = #level
		return string.format("<h%d>%s</h%d>", n, format_inline(content), n)
	end
end

-- 处理表格（表头 + 分隔 + 多行）
local function parse_table(rows)
	local html = { "<table>" }
	local header = rows[1]:gsub("^%|%s*", ""):gsub("%s*|%s*$", "")
	local cols = {}
	for col in header:gmatch("[^|]+") do
		table.insert(cols, "<th>" .. format_inline(col:match("^%s*(.-)%s*$")) .. "</th>")
	end
	table.insert(html, "<tr>" .. table.concat(cols) .. "</tr>")

	for i = 3, #rows do
		local line = rows[i]
		local cells = {}
		for cell in line:gsub("^%|%s*", ""):gsub("%s*|%s*$", ""):gmatch("[^|]+") do
			table.insert(cells, "<td>" .. format_inline(cell:match("^%s*(.-)%s*$")) .. "</td>")
		end
		table.insert(html, "<tr>" .. table.concat(cells) .. "</tr>")
	end
	table.insert(html, "</table>")
	return html
end

-- 处理代码块
local function parse_code_block(lines, start)
	local code = {}
	local i = start + 1
	while i <= #lines and not lines[i]:match("^```") do
		table.insert(code, escape_html(lines[i]))
		i = i + 1
	end
	return { "<pre>" .. table.concat(code, "\n") .. "</pre>" }, i
end

-- 数学块（$$...$$ 多行）
local function parse_math_block(lines, start)
	local math_lines = {}
	local i = start + 1
	while i <= #lines and not lines[i]:match("^%s*%$%$%s*$") do
		table.insert(math_lines, lines[i])
		i = i + 1
	end
	local html = {
		'<div class="math">',
		"\\[",
		table.concat(math_lines, "\n"),
		"\\]",
		"</div>",
	}
	return html, i
end

-- 脚注定义
local footnotes = {}
local function parse_footnote_definition(line)
	local key, def = line:match("^%[%^([%w%d%-_]+)%]:%s*(.*)")
	if key then
		footnotes[key] = def
		return true
	end
	return false
end

-------------------------------------------------------------
-- 主转换逻辑
-------------------------------------------------------------

local function convert_md(lines)
	local html = {}
	local i = 1
	local in_list, list_type = false, nil
	local table_buf = {}

	while i <= #lines do
		local line = lines[i]

		-- 空行：关闭表格或列表
		if line:match("^%s*$") then
			if in_list then
				table.insert(html, "</" .. list_type .. ">")
				in_list, list_type = false, nil
			end
			if #table_buf > 0 then
				for _, l in ipairs(parse_table(table_buf)) do
					table.insert(html, l)
				end
				table_buf = {}
			end
			i = i + 1

		-- 脚注定义
		elseif parse_footnote_definition(line) then
			i = i + 1

		-- 标题
		elseif line:match("^#+") then
			table.insert(html, parse_header(line))
			i = i + 1

		-- 数学块开始
		elseif line:match("^%s*%$%$%s*$") then
			local math_html
			math_html, i = parse_math_block(lines, i)
			for _, l in ipairs(math_html) do
				table.insert(html, l)
			end
			i = i + 1

		-- 代码块开始
		elseif line:match("^```") then
			local code_html
			code_html, i = parse_code_block(lines, i)
			for _, l in ipairs(code_html) do
				table.insert(html, l)
			end
			i = i + 1

		-- 表格起始
		elseif line:match("^%s*|") and lines[i + 1] and lines[i + 1]:match("^%s*|?%s*[-:|%s]+|?%s*$") then
			repeat
				table.insert(table_buf, lines[i])
				i = i + 1
			until not lines[i] or lines[i]:match("^%s*$") or not lines[i]:match("^%s*|")

		-- 有序/无序列表
		elseif line:match("^%s*[%-%*+]%s+") or line:match("^%s*%d+%.%s+") then
			local ordered = line:match("^%s*%d+%.%s+") ~= nil
			local tag = ordered and "ol" or "ul"
			if not in_list or list_type ~= tag then
				if in_list then
					table.insert(html, "</" .. list_type .. ">")
				end
				table.insert(html, "<" .. tag .. ">")
				in_list, list_type = true, tag
			end

			-- ✅ 将列表项内容提取并进行数学公式转换
			local content = line:gsub("^%s*[%-%*+%d%.]+%s+", "")
			table.insert(html, "<li>" .. format_inline(content) .. "</li>")

			i = i + 1

		-- 行内公式 / 普通段落
		else
			if in_list then
				table.insert(html, "</" .. list_type .. ">")
				in_list, list_type = false, nil
			end
			table.insert(html, "<p>" .. format_inline(line) .. "</p>")
			i = i + 1
		end
	end

	-- 如果文档结束前还有未关闭的列表，补上
	if in_list then
		table.insert(html, "</" .. list_type .. ">")
		in_list = false
		list_type = nil
	end

	-- 插入脚注段落
	if next(footnotes) then
		table.insert(html, "<hr><h3>脚注</h3><ol>")
		for key, val in pairs(footnotes) do
			table.insert(
				html,
				string.format('<li id="footnote-%s">%s <a href="#ref-%s">↩</a></li>', key, format_inline(val), key)
			)
		end
		table.insert(html, "</ol>")
	end

	return html
end

-------------------------------------------------------------
-- 输出 HTML 文件
-------------------------------------------------------------

local html_body = convert_md(lines)
local output_file = input_file:gsub("%.md$", ".html")
local out = io.open(output_file, "w")
if not out then
	print("❌ 无法写入文件: " .. output_file)
	os.exit(1)
end

out:write([[
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Markdown</title>
  <style>table,th,td{border:1px solid #ccc;border-collapse:collapse;padding:5px;}</style>
  <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
</head>
<body>
]])
for _, l in ipairs(html_body) do
	out:write(l .. "\n")
end
out:write("</body>\n</html>\n")
out:close()

print("✅ 转换完成：", output_file)
