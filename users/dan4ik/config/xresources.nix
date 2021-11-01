{ pywal }:

with pywal.special;
with pywal.colors;

''
  ! Settings
  URxvt.font: xft:Iosevka FT Extended:size=9
  URxvt.saveline: 22222
  URxvt.internalBorder: 15
  URxvt.scrollBar: false
  URxvt.iso14755: false

  ! Bindings
  URxvt.keysym.Control-Shift-C: eval:selection_to_clipboard
  URxvt.keysym.Control-Shift-V: eval:paste_clipboard
  URxvt.keysym.Control-Shift-U: url-select:select_next
  URxvt.keysym.Control-minus: resize-font:smaller
  URxvt.keysym.Control-equal: resize-font:bigger
  URxvt.keysym.Control-plus: resize-font:reset
  URxvt.keysym.Control-question: resize-font:show
  URxvt.keysym.Control-Shift-T: tabbedex:new_tab
  URxvt.keysym.Control-Shift-R: tabbedex:rename_tab
  URxvt.keysym.Control-Shift-W: tabbedex:kill_tab
  URxvt.keysym.Control-Next: tabbedex:next_tab
  URxvt.keysym.Control-Prior: tabbedex:prev_tab
  URxvt.keysym.Control-Left: \033[1;5D
  URxvt.keysym.Control-Right: \033[1;5C

  ! Perl
  URxvt.perl-ext-common: default,url-select,resize-font,tabbedex
  URxvt.resize-font.step: 1
  URvxt.url-select.button: 2
  URxvt.url-select.launcher: qutebrowser
  URxvt.url-select.underline: true
  URxvt.tabbedex.no-tabbedex-keys: yes
  URxvt.tabbedex.new-button: false
  URXvt.tabbedex.reopen-on-close: yes
  URxvt.tabbedex.autohide: yes
  URxvt.tabbedex.tabbar-fg: 5
  URxvt.tabbedex.tabbar-bg: 0
  URxvt.tabbedex.tab-fg: 15
  URxvt.tabbedex.tab-bg: 0
  URxvt.tabbedex.bell-fg: 0
  URxvt.tabbedex.bell-bg: 0
  URxvt.tabbedex.bell-tab-fg: 0
  URxvt.tabbedex.bell-tab-bg: 0
  URxvt.tabbedex.title-fg: 15
  URxvt.tabbedex.title-bg: 0

  ! Colors
  *.foreground: ${foreground}
  *.background: ${background}
  *.cursorColor: ${cursor}

  *.color0: ${color0}
  *.color1: ${color1}
  *.color2: ${color2}
  *.color3: ${color3}
  *.color4: ${color4}
  *.color5: ${color5}
  *.color6: ${color6}
  *.color7: ${color7}
  *.color8: ${color8}
  *.color9: ${color9}
  *.color10: ${color10}
  *.color11: ${color11}
  *.color12: ${color12}
  *.color13: ${color13}
  *.color14: ${color14}
  *.color15: ${color15}
''
