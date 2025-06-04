/* See LICENSE file for copyright and license details. */

/* appearance */

/* alphasystray */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;     /* 0 means no systray */


static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int gappih    = 10;       /* horiz inner gap between windows */
static const unsigned int gappiv    = 10;       /* vert inner gap between windows */
static const unsigned int gappoh    = 10;       /* horiz outer gap between windows and screen edge */
static const unsigned int gappov    = 10;       /* vert outer gap between windows and screen edge */
static       int smartgaps          = 1;        /* 1 means no outer gap when there is only one window */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const Bool viewontag         = True;     /* Switch view on tag switch */
static const char *fonts[]          = {
	"SauceCodePro Nerd Font Mono:size=16",
	"LXGW WenKai Mono:size=16",
	"JoyPixels:pixelsize=16:antialias=true:autohint=true"
};
//static const char dmenufont[]       = "SauceCodePro Nerd Font Mono:size=16";
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#1f2f3f";
static const char col_border[]      = "#42A5F5";
//static const unsigned int baralpha  = 0xd0;
static const unsigned int baralpha  = 0x80;
static const unsigned int borderalpha = OPAQUE;
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_border  },
	[SchemeHid]  = { col_cyan,  col_gray1, col_border  },
};

static const unsigned int alphas[][3]      = {
	/*               fg      bg        border     */
	[SchemeNorm] = { OPAQUE, baralpha, borderalpha },
	[SchemeSel]  = { OPAQUE, baralpha, borderalpha },
};

typedef struct {
	const char *name;
	const void *cmd;
} Sp;
const char *spcmd1[] = {"st", "-n", "spterm", "-g", "80x24", NULL };
const char *spcmd2[] = {"st", "-n", "spfm", "-g", "80x24", "-e", "ranger", NULL };
const char *spcmd3[] = {"st", "-n", "calcurse", "-g", "80x24", "-e", "calcurse", NULL };
static Sp scratchpads[] = {
	/* name          cmd  */
	{"spterm",      spcmd1},
	{"spranger",    spcmd2},
	{"calcurse",    spcmd3},
};

/* tagging */
//static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };
//static const char *tags[] = { "\uf46d", "\uf120", "\ufa9e", "\uf04b", "\uf11b", "\uf8d7", "\ufc58", "\uf42f", "\ufcf4" };
static const char *tags[] = { "🏡", "💻", "🌐", "📺", "🎮", "🎧", "🛸", "📧","🎯" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
	{ NULL,      "spterm",    NULL,       SPTAG(0),     1,           -1 },
	{ NULL,      "spfm",      NULL,       SPTAG(1),     1,           -1 },
	{ NULL,      "calcurse",  NULL,       SPTAG(2),     1,           -1 },
};

/* layout(s) */
static const float mfact     = 0.5; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */

#define FORCE_VSPLIT 1  /* nrowgrid layout: force two clients to always split vertically */
#include "vanitygaps.c"

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "[M]",      monocle },
	{ "[@]",      spiral },
	{ "[\\]",     dwindle },
	{ "H[]",      deck },
	{ "TTT",      bstack },
	{ "===",      bstackhoriz },
	{ "HHH",      grid },
	{ "###",      nrowgrid },
	{ "---",      horizgrid },
	{ ":::",      gaplessgrid },
	{ "|M|",      centeredmaster },
	{ ">M>",      centeredfloatingmaster },
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ NULL,       NULL },
};

/* key definitions */
#include <X11/XF86keysym.h>
#define MODKEY Mod4Mask
#define AltMask Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ AltMask|ShiftMask,            KEY,      view,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/bash", "-c", cmd, NULL } }

/* commands */
/* start application */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-c", "-g", "3", "-l", "15", NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *browsercmd[]  = { "google-chrome-stable", NULL };
static const char *screenshotcmd[] = { "flameshot", "gui", NULL };

/* scripts control */
static const char *layoutmenu_cmd = "/home/kuring/.local/mbin/dwm/dwm-layoutmenu.sh";

#include "movestack.c"
static Key keys[] = {
	/* modifier                     key        function        argument */ 
	/* default */
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	
	{ MODKEY|ShiftMask,             XK_q,      killclient,     {0} },
	{ MODKEY|ControlMask,           XK_q,      quit,           {0} },
	{ MODKEY|ShiftMask,             XK_b,      togglebar,      {0} },
  { MODKEY|ShiftMask,             XK_h,      incnmaster,     {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_l,      incnmaster,     {.i = -1 } },
  { MODKEY,                       XK_space,  setlayout,      {0} },
  { MODKEY|ShiftMask,             XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },

	{ MODKEY,                       XK_e,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_u,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_n,      viewtoleft,     {0} },
	{ MODKEY,                       XK_i,      viewtoright,    {0} },
	{ MODKEY|ShiftMask,             XK_n,      tagtoleft,      {0} },
	{ MODKEY|ShiftMask,             XK_i,      tagtoright,     {0} },

	{ MODKEY|ShiftMask,             XK_f,      fullscreen,     {0} },
	{ MODKEY,                       XK_k,      hidewin,        {0} },
	{ MODKEY|ShiftMask,             XK_k,      restorewin,     {0} },
	{ MODKEY,                       XK_o,      hideotherwins,  {0}},
	{ MODKEY|ShiftMask,             XK_o,      restoreotherwins, {0}},

	{ MODKEY,              XK_apostrophe,      togglescratch,  {.ui = 0 } },
	{ MODKEY,                       XK_r,      togglescratch,  {.ui = 1 } },
	{ MODKEY,                       XK_x,      togglescratch,  {.ui = 2 } },

	/* start a application or a shell script */
	{ MODKEY,                       XK_s,      spawn,          {.v = dmenucmd } },
	{ MODKEY,                       XK_d,      spawn,          SHCMD("dmenu_drun") },
	{ MODKEY,                       XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_c,      spawn,          {.v = browsercmd } },
	{ 0,                            XK_Print,  spawn,          {.v = screenshotcmd } },
	{ 0,              XF86XK_AudioLowerVolume, spawn,          SHCMD("vol_down.sh") },
	{ 0,              XF86XK_AudioMute,        spawn,          SHCMD("vol_toggle.sh") },
	{ 0,              XF86XK_AudioRaiseVolume, spawn,          SHCMD("vol_up.sh") },
	{ MODKEY,         XK_bracketleft,          spawn,          SHCMD("vol_down.sh") },
	{ MODKEY,         XK_backslash,            spawn,          SHCMD("vol_toggle.sh") },
	{ MODKEY,         XK_bracketright,         spawn,          SHCMD("vol_up.sh") },
	{ MODKEY,                       XK_b,      spawn,          SHCMD("wp_change.sh") },
	{ MODKEY|ShiftMask,             XK_w,      spawn,          SHCMD("setxmodmap-qwerty.sh") },
	{ MODKEY|ShiftMask,             XK_m,      spawn,          SHCMD("setxmodmap-colemak.sh") },
	{ MODKEY|ShiftMask,     XK_BackSpace,      spawn,          SHCMD("sysact") },
	{ MODKEY,                       XK_p,      spawn,          SHCMD("tog_touchpad.sh") },
	{ MODKEY|ShiftMask,             XK_s,      spawn,          SHCMD("slock -m \"$(cowsay \"$(fortune)\" | lolcat -ft)\"") },
	{ MODKEY|ControlMask,           XK_s,      spawn,          SHCMD("$(killall screenkey && notify-send Screenkey Off) || $(notify-send Screenkey On && screenkey)") },
	{ MODKEY,                       XK_grave,  spawn,          SHCMD("dmenuunicode") },
	{ ShiftMask,                    XK_Print,  spawn,          SHCMD("maimpick") },
	{ MODKEY,                       XK_F9,     spawn,          SHCMD("dmenumount") },
	{ MODKEY,                       XK_F10,    spawn,          SHCMD("dmenuumount") },


	/* change layouts */
	{ AltMask|ControlMask,          XK_t,      setlayout,      {.v = &layouts[0]} },   /* "[]="  tile */
	{ AltMask|ControlMask,          XK_m,      setlayout,      {.v = &layouts[1]} },   /* "[M]"  monocle */
	{ AltMask|ControlMask,          XK_b,      setlayout,      {.v = &layouts[2]} },   /* "[@]"  spiral */
	{ AltMask|ControlMask,          XK_k,      setlayout,      {.v = &layouts[3]} },   /* "[\\]" dwindle */
	{ AltMask|ControlMask,          XK_h,      setlayout,      {.v = &layouts[4]} },   /* "H[]"  deck */
	{ AltMask|ControlMask,          XK_z,      setlayout,      {.v = &layouts[5]} },   /* "TTT"  bstack */
	{ AltMask|ControlMask,          XK_x,      setlayout,      {.v = &layouts[6]} },   /* "==="  bstackhoriz */
	{ AltMask|ControlMask,          XK_a,      setlayout,      {.v = &layouts[7]} },   /* "HHH"  grid */
	{ AltMask|ControlMask,          XK_r,      setlayout,      {.v = &layouts[8]} },   /* "###"  nrowgrid */
	{ AltMask|ControlMask,          XK_s,      setlayout,      {.v = &layouts[9]} },   /* "---"  horizgrid */
	{ AltMask|ControlMask,          XK_d,      setlayout,      {.v = &layouts[10]} },  /* ":::"  gaplessgrid */
	{ AltMask|ControlMask,          XK_c,      setlayout,      {.v = &layouts[11]} },  /* "|M|"  centeredmaster */
	{ AltMask|ControlMask,          XK_v,      setlayout,      {.v = &layouts[12]} },  /* ">M>"  centeredfloatingmaster */
	{ AltMask|ControlMask,          XK_f,      setlayout,      {.v = &layouts[13]} },  /* "><>"  float */

	/* move stack*/
  { MODKEY|ShiftMask,             XK_e,      movestack,     {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_u,      movestack,     {.i = -1 } },
	
	/* dwm-cfacts-vanitygaps-6.2_combo.diff */
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY|ControlMask,           XK_h,      setcfact,       {.f = +0.25} },
	{ MODKEY|ControlMask,           XK_l,      setcfact,       {.f = -0.25} },
	{ MODKEY|ControlMask,           XK_z,      setcfact,       {.f = +0.00} },

	{ MODKEY|AltMask,               XK_u,      incrgaps,       {.i = +1 } }, /* increase all gaps */
	{ MODKEY|AltMask|ShiftMask,     XK_u,      incrgaps,       {.i = -1 } }, /* decrease all gaps */
	{ MODKEY|AltMask,               XK_i,      incrigaps,      {.i = +1 } }, /* increase inner gaps */
	{ MODKEY|AltMask|ShiftMask,     XK_i,      incrigaps,      {.i = -1 } }, /* decrease inner gaps */
	{ MODKEY|AltMask,               XK_o,      incrogaps,      {.i = +1 } }, /* increase outer gags */
	{ MODKEY|AltMask|ShiftMask,     XK_o,      incrogaps,      {.i = -1 } }, /* decrease outer gags */
	{ MODKEY|AltMask,               XK_h,      incrihgaps,     {.i = +1 } }, /* increase inner horizontal gaps */
	{ MODKEY|AltMask|ShiftMask,     XK_h,      incrihgaps,     {.i = -1 } }, /* decrease inner horizontal gaps */
	{ MODKEY|AltMask,               XK_v,      incrivgaps,     {.i = +1 } }, /* increase inner vertical gaps */
	{ MODKEY|AltMask|ShiftMask,     XK_v,      incrivgaps,     {.i = -1 } }, /* decrease inner vertical gaps */
	{ MODKEY|AltMask,               XK_n,      incrohgaps,     {.i = +1 } }, /* increase outer horizontal gaps */
	{ MODKEY|AltMask|ShiftMask,     XK_n,      incrohgaps,     {.i = -1 } }, /* decrease outer horizontal gaps */
	{ MODKEY|AltMask,               XK_e,      incrovgaps,     {.i = +1 } }, /* increase outer vertical gaps */
	{ MODKEY|AltMask|ShiftMask,     XK_e,      incrovgaps,     {.i = -1 } }, /* decrease outer vertical gaps */
	{ MODKEY|AltMask,               XK_0,      togglegaps,     {0} },        /* reset gaps back to default */
	{ MODKEY|AltMask|ShiftMask,     XK_0,      defaultgaps,    {0} },        /* toggle gaps on and off */
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        layoutmenu,     {0} }, /* layoutmenu */
	{ ClkWinTitle,          0,              Button1,        togglewin,      {0} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button1,        spawn,          SHCMD("st -e sb-notify -a") },
	{ ClkStatusText,        0,              Button2,        spawn,          SHCMD("sb-notify -c") },
	{ ClkStatusText,        0,              Button3,        spawn,          SHCMD("sb-notify -b") },
	{ ClkStatusText,        0,              Button4,        spawn,          SHCMD("vol_up.sh") },
	{ ClkStatusText,        0,              Button5,        spawn,          SHCMD("vol_down.sh") },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

