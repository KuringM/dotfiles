# pyright: reportMissingImports=false
import platform
import subprocess
import time
import re
from datetime import datetime
from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer, get_options
from kitty.utils import color_as_int
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_attributed_string,
    draw_title,
)

opts = get_options()

# ===== 配色定义 =====
icon_fg = as_rgb(color_as_int(opts.color9))
icon_bg = as_rgb(color_as_int(opts.color0))
bat_text_color = as_rgb(color_as_int(opts.color10))
clock_color = as_rgb(color_as_int(opts.color9))
date_color = as_rgb(color_as_int(opts.color8))

SEPARATOR_SYMBOL, SOFT_SEPARATOR_SYMBOL = ("", "")
RIGHT_MARGIN = 1
REFRESH_TIME = 1
# ICON = "   "
# ICON = " 梅 "
ICON = " 🌕  "

# ===== 电池状态符号定义 =====
UNPLUGGED_ICONS = {
    10: "",
    20: "",
    30: "",
    40: "",
    50: "",
    60: "",
    70: "",
    80: "",
    90: "",
    100: "",
}
PLUGGED_ICONS = {1: ""}
UNPLUGGED_COLORS = {
    15: as_rgb(color_as_int(opts.color1)),
    16: as_rgb(color_as_int(opts.color15)),
}
PLUGGED_COLORS = {
    15: as_rgb(color_as_int(opts.color1)),
    16: as_rgb(color_as_int(opts.color6)),
    99: as_rgb(color_as_int(opts.color6)),
    100: as_rgb(color_as_int(opts.color2)),
}

_last_battery_info = None
_last_battery_time = 0


# ===== 工具函数 =====
def nearest_key(d: dict, value: int) -> int:
    """找到最接近 value 的键"""
    return min(d.keys(), key=lambda x: abs(x - value))


# ===== 右侧模块: 电池电量、时间、日期 =====

"""
获取电池状态(缓存1秒)
兼容 Linux/macOS, 使用正则匹配 macOS 电池百分比
返回 [(颜色, 文本), (颜色, 图标)]
"""


def get_battery_cells() -> list:
    global _last_battery_info, _last_battery_time
    now = time.time()
    if _last_battery_info and now - _last_battery_time < REFRESH_TIME:
        return _last_battery_info

    try:
        sysname = platform.system()
        if sysname == "Linux":
            with open("/sys/class/power_supply/BAT0/status") as f:
                status = f.read().strip()
            with open("/sys/class/power_supply/BAT0/capacity") as f:
                percent = int(f.read().strip())
        elif sysname == "Darwin":
            out = subprocess.check_output(["pmset", "-g", "batt"], text=True)
            # 使用正则提取百分比
            m = re.search(r"(\d+)%", out)
            percent = int(m.group(1)) if m else 0
            # 判断状态
            if "discharging" in out.lower():
                status = "Discharging"
            elif "charging" in out.lower():
                status = "Charging"
            else:
                status = "Full"
        else:
            return []

        if status.lower().startswith("discharging"):
            icon_color = UNPLUGGED_COLORS[nearest_key(UNPLUGGED_COLORS, percent)]
            icon = UNPLUGGED_ICONS[nearest_key(UNPLUGGED_ICONS, percent)]
        elif status.lower().startswith("not charging"):
            icon_color = UNPLUGGED_COLORS[nearest_key(UNPLUGGED_COLORS, percent)]
            icon = PLUGGED_ICONS[nearest_key(PLUGGED_ICONS, 1)]
        else:
            icon_color = PLUGGED_COLORS[nearest_key(PLUGGED_COLORS, percent)]
            icon = PLUGGED_ICONS[nearest_key(PLUGGED_ICONS, 1)]

        _last_battery_info = [(bat_text_color, f"{percent}% "), (icon_color, icon)]
        _last_battery_time = now
        return _last_battery_info
    except Exception:
        return []


# 组合右侧状态栏元素, 返回[(fg, text), ...]
def build_right_status_cells() -> list:
    cells = []
    # cells.extend(get_battery_cells())
    cells.append((clock_color, datetime.now().strftime(" %H:%M")))
    cells.append((date_color, datetime.now().strftime(" %d.%m.%Y")))
    return cells


# ===== 绘制函数 =====
timer_id = None
right_status_length = -1


def _draw_icon(screen: Screen, index: int) -> int:
    if index != 1:
        return 0
    fg, bg = screen.cursor.fg, screen.cursor.bg
    screen.cursor.fg = icon_fg
    screen.cursor.bg = icon_bg
    screen.draw(ICON)
    screen.cursor.fg, screen.cursor.bg = fg, bg
    screen.cursor.x = len(ICON)
    return screen.cursor.x


def _draw_tab_title(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    if screen.cursor.x >= screen.columns - right_status_length:
        return screen.cursor.x
    tab_bg = screen.cursor.bg
    tab_fg = screen.cursor.fg
    default_bg = as_rgb(int(draw_data.default_bg))
    if extra_data.next_tab:
        next_tab_bg = as_rgb(draw_data.tab_bg(extra_data.next_tab))
        needs_soft_separator = next_tab_bg == tab_bg
    else:
        next_tab_bg = default_bg
        needs_soft_separator = False
    if screen.cursor.x <= len(ICON):
        screen.cursor.x = len(ICON)
    screen.draw(" ")
    screen.cursor.bg = tab_bg
    draw_title(draw_data, screen, tab, index)
    if not needs_soft_separator:
        screen.draw(" ")
        screen.cursor.fg = tab_bg
        screen.cursor.bg = next_tab_bg
        screen.draw(SEPARATOR_SYMBOL)
    else:
        prev_fg = screen.cursor.fg
        if tab_bg == tab_fg:
            screen.cursor.fg = default_bg
        elif tab_bg != default_bg:
            c1 = draw_data.inactive_bg.contrast(draw_data.default_bg)
            c2 = draw_data.inactive_bg.contrast(draw_data.inactive_fg)
            if c1 < c2:
                screen.cursor.fg = default_bg
        screen.draw(" " + SOFT_SEPARATOR_SYMBOL)
        screen.cursor.fg = prev_fg
    end = screen.cursor.x
    return end


# 绘制右侧状态栏
def _draw_right_status(screen: Screen, is_last: bool, cells: list) -> int:
    if not is_last:
        return 0
    draw_attributed_string(Formatter.reset, screen)
    screen.cursor.x = screen.columns - right_status_length
    for color, status in cells:
        screen.cursor.fg = color
        screen.draw(status)
    screen.cursor.bg = 0
    return screen.cursor.x


# 定时刷新, 标记 Tab Bar 需要重绘
def _redraw_tab_bar(_):
    tm = get_boss().active_tab_manager
    if tm:
        tm.mark_tab_bar_dirty()


# 主绘制入口
def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global timer_id, right_status_length
    if timer_id is None:
        timer_id = add_timer(_redraw_tab_bar, REFRESH_TIME, True)

    right_cells = build_right_status_cells()
    right_status_length = RIGHT_MARGIN + sum(len(str(cell[1])) for cell in right_cells)

    # 绘制 ICON
    _draw_icon(screen, index)

    # 绘制 Tab 标题
    _draw_tab_title(
        draw_data,
        screen,
        tab,
        before,
        max_title_length,
        index,
        is_last,
        extra_data,
    )

    # 绘制右侧
    _draw_right_status(screen, is_last, right_cells)

    return screen.cursor.x
