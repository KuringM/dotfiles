#!/bin/sh

# cat <<EOF | xmenu
# []= Tiled Layout	0
# ><> Floating Layout	1
# [M] Monocle Layout	2
# EOF

# []= tile 
# [M] monocle
# [@] spiral
# [\\] dwindle
# H[] deck
# TTT bstack
# === bstackhoriz
# HHH grid
# ### nrowgrid
# --- horizgrid
# ::: gaplessgrid
# |M| centeredmaster
# >M> centeredfloatingmaster
# ><> Floating

cat <<EOF | xmenu
[]= Tiled		0
[M] Monocle		1
[@] spiral	2
[\\] dwindle	3
H[] deck	4
TTT bstack	5
=== bstackhoriz		6
HHH grid	7
### nrowgrid	8
--- horizgrid		9
::: gaplessgrid		10
|M| centeredmaster	11
>M> centeredfloatingmaster	12
><> Floating	13
EOF
