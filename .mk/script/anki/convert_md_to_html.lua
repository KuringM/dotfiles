-- 获取命令行参数
local input_file = arg[1]
if not input_file then
	print("用法: lua convert_md_to_html.lua 文件名.md")
	os.exit(1)
end

if not input_file:match("%.md$") then
	print("错误: 仅支持 .md 文件")
	os.exit(1)
end

-- HTML 字符实体转义
local function escape_html(str)
	return str:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
end

-- 行内数学 $...$ → \( ... \)
local function convert_inline_tex(content)
	return content:gsub("([^\\])%$(.-)%$", "%1\\(%2\\)")
end

-- Markdown → HTML
local function md_to_html(lines)
	local html_lines = {}
	local in_code_block = false
	local in_list = false
	local in_tex_block = false
	local tex_buffer = {}

	for _, line in ipairs(lines) do
		-- 单行块级公式
		if line:match("^%s*%$%$.*%$%$%s*$") and not line:match("^%s*%$%$%s*$") then
			local content = line:match("%$%$(.-)%$%$")
			content = content and content:gsub("^%s+", ""):gsub("%s+$", "") or ""
			table.insert(html_lines, '<div class="math">')
			table.insert(html_lines, "\\[" .. content .. "\\]")
			table.insert(html_lines, "</div>")

		-- 多行块级公式起止标记
		elseif line:match("^%s*%$%$%s*$") then
			if in_tex_block then
				table.insert(html_lines, '<div class="math">')
				table.insert(html_lines, "\\[")
				for _, l in ipairs(tex_buffer) do
					table.insert(html_lines, l)
				end
				table.insert(html_lines, "\\]")
				table.insert(html_lines, "</div>")
				tex_buffer = {}
				in_tex_block = false
			else
				in_tex_block = true
			end
		elseif in_tex_block then
			table.insert(tex_buffer, line)
		elseif line:match("^```") then
			if in_code_block then
				table.insert(html_lines, "</pre>")
				in_code_block = false
			else
				table.insert(html_lines, "<pre>")
				in_code_block = true
			end
		elseif in_code_block then
			table.insert(html_lines, escape_html(line))
		elseif line:match("^#") then
			local level = #line:match("^(#+)")
			local content = line:match("^#+%s*(.*)") or ""
			content = convert_inline_tex(content)
			table.insert(html_lines, string.format("<h%d>%s</h%d>", level, content, level))
		elseif line:match("^%s*[-*+]%s+") then
			if not in_list then
				table.insert(html_lines, "<ul>")
				in_list = true
			end
			local content = line:match("^%s*[-*+]%s+(.*)") or ""
			content = convert_inline_tex(content)
			table.insert(html_lines, "<li>" .. content .. "</li>")
		else
			if in_list then
				table.insert(html_lines, "</ul>")
				in_list = false
			end

			local content = line:gsub("%*%*(.-)%*%*", "<strong>%1</strong>"):gsub("%*(.-)%*", "<em>%1</em>")
			content = convert_inline_tex(content)

			if content:match("%S") then
				table.insert(html_lines, "<p>" .. content .. "</p>")
			else
				table.insert(html_lines, "")
			end
		end
	end

	if in_list then
		table.insert(html_lines, "</ul>")
	end
	if in_code_block then
		table.insert(html_lines, "</pre>")
	end
	if in_tex_block then
		table.insert(html_lines, '<div class="math">')
		table.insert(html_lines, "\\[")
		for _, l in ipairs(tex_buffer) do
			table.insert(html_lines, l)
		end
		table.insert(html_lines, "\\]")
		table.insert(html_lines, "</div>")
	end

	return html_lines
end

-- 读取文件内容
local lines = {}
local f = io.open(input_file, "r")
if not f then
	print("无法读取文件：" .. input_file)
	os.exit(1)
end

for line in f:lines() do
	table.insert(lines, line)
end
f:close()

-- 处理并写入输出
local html_body = md_to_html(lines)
local output_file = input_file:gsub("%.md$", ".html")
local out = io.open(output_file, "w")
if not out then
	print("无法写入文件：" .. output_file)
	os.exit(1)
end

-- out:write([[
-- <!DOCTYPE html>
-- <html>
-- <head>
--   <meta charset="UTF-8">
--   <title>Markdown</title>
--   <script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
-- </head>
-- <body>
-- ]])
for _, line in ipairs(html_body) do
	out:write(line .. "\n")
end
-- out:write("</body>\n</html>\n")
out:close()

print("已生成 HTML 文件：" .. output_file)
