let g:airline#themes#solarized16#palette = {}

function! airline#themes#solarized16#refresh()
  """"""""""""""""""""""""""""""""""""""""""""""""
  " Options
  """"""""""""""""""""""""""""""""""""""""""""""""
  let s:background  = get(g:, 'airline_solarized16_bg', &background)
  let s:ansi_colors = get(g:, 'solarized16_termcolors', 16) != 256 && &t_Co >= 16 ? 1 : 0
  let s:tty         = &t_Co == 8

  """"""""""""""""""""""""""""""""""""""""""""""""
  " Colors
  """"""""""""""""""""""""""""""""""""""""""""""""
  " Base colors
  let s:base03  = {'t': s:ansi_colors ?   0 : (s:tty ? '0' : 234), 'g': '#002b36'}
  let s:base02  = {'t': s:ansi_colors ?   0 : (s:tty ? '0' : 235), 'g': '#073642'}
  let s:base01  = {'t': s:ansi_colors ?   8 : (s:tty ? '0' : 240), 'g': '#586e75'}
  let s:base00  = {'t': s:ansi_colors ?   8 : (s:tty ? '7' : 241), 'g': '#657b83'}
  let s:base0   = {'t': s:ansi_colors ?   7 : (s:tty ? '7' : 244), 'g': '#839496'}
  let s:base1   = {'t': s:ansi_colors ?   7 : (s:tty ? '7' : 245), 'g': '#93a1a1'}
  let s:base2   = {'t': s:ansi_colors ?   7 : (s:tty ? '7' : 254), 'g': '#eee8d5'}
  let s:base3   = {'t': s:ansi_colors ?  15 : (s:tty ? '7' : 230), 'g': '#fdf6e3'}
  let s:yellow  = {'t': s:ansi_colors ?  11 : (s:tty ? '3' : 136), 'g': '#b58900'}
  let s:orange  = {'t': s:ansi_colors ?   3 : (s:tty ? '1' : 166), 'g': '#cb4b16'}
  let s:red     = {'t': s:ansi_colors ?   9 : (s:tty ? '1' : 160), 'g': '#dc322f'}
  let s:magenta = {'t': s:ansi_colors ?  13 : (s:tty ? '5' : 125), 'g': '#d33682'}
  let s:violet  = {'t': s:ansi_colors ?   5 : (s:tty ? '5' : 61 ), 'g': '#6c71c4'}
  let s:blue    = {'t': s:ansi_colors ?  12 : (s:tty ? '4' : 33 ), 'g': '#268bd2'}
  let s:cyan    = {'t': s:ansi_colors ?   6 : (s:tty ? '6' : 37 ), 'g': '#2aa198'}
  let s:green   = {'t': s:ansi_colors ?   2 : (s:tty ? '2' : 64 ), 'g': '#859900'}

  " Extra colors
  let s:black           = {'t': s:ansi_colors ?   0 : (s:tty ? '0' : 16 ), 'g': '#000000'}
  let s:white           = {'t': s:ansi_colors ?  15 : (s:tty ? '7' : 231), 'g': '#ffffff'}
  let s:darkestgreen    = {'t': s:ansi_colors ?   0 : (s:tty ? '0' : 22 ), 'g': '#005f00'}
  let s:darkgreen       = {'t': s:ansi_colors ?   0 : (s:tty ? '0' : 28 ), 'g': '#008700'}
  let s:mediumgreen     = {'t': s:ansi_colors ?   2 : (s:tty ? '2' : 70 ), 'g': '#5faf00'}
  let s:brightgreen     = {'t': s:ansi_colors ?  10 : (s:tty ? '2' : 148), 'g': '#afd700'}
  let s:darkestcyan     = {'t': s:ansi_colors ?   0 : (s:tty ? '4' : 23 ), 'g': '#005f5f'}
  let s:mediumcyan      = {'t': s:ansi_colors ?  14 : (s:tty ? '4' : 117), 'g': '#87d7ff'}
  let s:darkestblue     = {'t': s:ansi_colors ?   4 : (s:tty ? '4' : 24 ), 'g': '#005f87'}
  let s:darkblue        = {'t': s:ansi_colors ?   4 : (s:tty ? '4' : 31 ), 'g': '#0087af'}
  let s:darkestred      = {'t': s:ansi_colors ?   1 : (s:tty ? '1' : 52 ), 'g': '#5f0000'}
  let s:darkred         = {'t': s:ansi_colors ?   1 : (s:tty ? '1' : 88 ), 'g': '#870000'}
  let s:mediumred       = {'t': s:ansi_colors ?   9 : (s:tty ? '1' : 124), 'g': '#af0000'}
  let s:brightred       = {'t': s:ansi_colors ?   9 : (s:tty ? '1' : 160), 'g': '#d70000'}
  let s:brightestred    = {'t': s:ansi_colors ?   9 : (s:tty ? '1' : 196), 'g': '#ff0000'}
  let s:darkestpurple   = {'t': s:ansi_colors ?   5 : (s:tty ? '5' : 55 ), 'g': '#5f00af'}
  let s:mediumpurple    = {'t': s:ansi_colors ?   5 : (s:tty ? '5' : 98 ), 'g': '#875fd7'}
  let s:brightpurple    = {'t': s:ansi_colors ?  13 : (s:tty ? '5' : 189), 'g': '#d7d7ff'}
  let s:brightorange    = {'t': s:ansi_colors ?   3 : (s:tty ? '3' : 208), 'g': '#ff8700'}
  let s:brightestorange = {'t': s:ansi_colors ?   3 : (s:tty ? '3' : 214), 'g': '#ffaf00'}
  let s:gray0           = {'t': s:ansi_colors ?   0 : (s:tty ? '0' : 233), 'g': '#121212'}
  let s:gray1           = {'t': s:ansi_colors ?   0 : (s:tty ? '0' : 235), 'g': '#262626'}
  let s:gray2           = {'t': s:ansi_colors ?   0 : (s:tty ? '0' : 236), 'g': '#303030'}
  let s:gray3           = {'t': s:ansi_colors ?   0 : (s:tty ? '0' : 239), 'g': '#4e4e4e'}
  let s:gray4           = {'t': s:ansi_colors ?   8 : (s:tty ? '0' : 240), 'g': '#585858'}
  let s:gray5           = {'t': s:ansi_colors ?   8 : (s:tty ? '0' : 241), 'g': '#626262'}
  let s:gray6           = {'t': s:ansi_colors ?   8 : (s:tty ? '0' : 244), 'g': '#808080'}
  let s:gray7           = {'t': s:ansi_colors ?   8 : (s:tty ? '0' : 245), 'g': '#8a8a8a'}
  let s:gray8           = {'t': s:ansi_colors ?   7 : (s:tty ? '0' : 247), 'g': '#9e9e9e'}
  let s:gray9           = {'t': s:ansi_colors ?   7 : (s:tty ? '0' : 250), 'g': '#bcbcbc'}
  let s:gray10          = {'t': s:ansi_colors ?   7 : (s:tty ? '0' : 252), 'g': '#d0d0d0'}

  """"""""""""""""""""""""""""""""""""""""""""""""
  " Simple mappings
  " NOTE: These are easily tweakable mappings. The actual mappings get
  " the specific gui and terminal colors from the base color dicts.
  """"""""""""""""""""""""""""""""""""""""""""""""
  " Normal mode
  let s:N1 = [s:darkestgreen, s:brightgreen, '']
  "let s:N2 = [s:cyan, s:darkblue, '']
  "let s:N3 = [s:base3, s:base01, '']
  let s:N2 = [s:base3, s:base01, '']
  let s:N3 = [s:base0, s:base02, '']
  let s:NF = [s:orange, s:N3[1], '']
  let s:NW = [s:base3, s:orange, '']
  let s:NM = [s:base2, s:N3[1], '']
  let s:NMi = [s:base0, s:base03, '']

  " Insert mode
  let s:I1 = [s:white, s:blue, 'bold']
  let s:I2 = s:N2
  let s:I3 = s:N3
  let s:IF = s:NF
  let s:IM = s:NM

  " Visual mode
  let s:V1 = [s:darkred, s:brightorange, 'bold']
  let s:V2 = s:N2
  let s:V3 = s:N3
  let s:VF = s:NF
  let s:VM = s:NM

  " Replace mode
  let s:R1 = [s:white, s:violet, 'bold']
  let s:R2 = s:N2
  let s:R3 = s:N3
  let s:RM = s:NM
  let s:RF = s:NF

  " Inactive, according to VertSplit in solarized
  let s:IA = [s:base0, s:base03, '']

  """"""""""""""""""""""""""""""""""""""""""""""""
  " Actual mappings
  " WARNING: Don't modify this section unless necessary.
  """"""""""""""""""""""""""""""""""""""""""""""""
  let s:NFa = [s:NF[0].g, s:NF[1].g, s:NF[0].t, s:NF[1].t, s:NF[2]]
  let s:IFa = [s:IF[0].g, s:IF[1].g, s:IF[0].t, s:IF[1].t, s:IF[2]]
  let s:VFa = [s:VF[0].g, s:VF[1].g, s:VF[0].t, s:VF[1].t, s:VF[2]]
  let s:RFa = [s:RF[0].g, s:RF[1].g, s:RF[0].t, s:RF[1].t, s:RF[2]]

  let g:airline#themes#solarized16#palette.accents = {
        \ 'red': s:NFa,
        \ }

  let g:airline#themes#solarized16#palette.inactive = airline#themes#generate_color_map(
        \ [s:IA[0].g, s:IA[1].g, s:IA[0].t, s:IA[1].t, s:IA[2]],
        \ [s:IA[0].g, s:IA[1].g, s:IA[0].t, s:IA[1].t, s:IA[2]],
        \ [s:IA[0].g, s:IA[1].g, s:IA[0].t, s:IA[1].t, s:IA[2]])
  let g:airline#themes#solarized16#palette.inactive_modified = {
        \ 'airline_c': [s:NMi[0].g, '', s:NMi[0].t, '', s:NMi[2]]}

  let g:airline#themes#solarized16#palette.normal = airline#themes#generate_color_map(
        \ [s:N1[0].g, s:N1[1].g, s:N1[0].t, s:N1[1].t, s:N1[2]],
        \ [s:N2[0].g, s:N2[1].g, s:N2[0].t, s:N2[1].t, s:N2[2]],
        \ [s:N3[0].g, s:N3[1].g, s:N3[0].t, s:N3[1].t, s:N3[2]])

  let g:airline#themes#solarized16#palette.normal.airline_warning = [
        \ s:NW[0].g, s:NW[1].g, s:NW[0].t, s:NW[1].t, s:NW[2]]

  let g:airline#themes#solarized16#palette.normal_modified = {
        \ 'airline_c': [s:NM[0].g, s:NM[1].g,
        \ s:NM[0].t, s:NM[1].t, s:NM[2]]}

  let g:airline#themes#solarized16#palette.normal_modified.airline_warning =
        \ g:airline#themes#solarized16#palette.normal.airline_warning

  let g:airline#themes#solarized16#palette.insert = airline#themes#generate_color_map(
        \ [s:I1[0].g, s:I1[1].g, s:I1[0].t, s:I1[1].t, s:I1[2]],
        \ [s:I2[0].g, s:I2[1].g, s:I2[0].t, s:I2[1].t, s:I2[2]],
        \ [s:I3[0].g, s:I3[1].g, s:I3[0].t, s:I3[1].t, s:I3[2]])

  let g:airline#themes#solarized16#palette.insert.airline_warning =
        \ g:airline#themes#solarized16#palette.normal.airline_warning

  let g:airline#themes#solarized16#palette.insert_modified = {
        \ 'airline_c': [s:IM[0].g, s:IM[1].g,
        \ s:IM[0].t, s:IM[1].t, s:IM[2]]}

  let g:airline#themes#solarized16#palette.insert_modified.airline_warning =
        \ g:airline#themes#solarized16#palette.normal.airline_warning

  let g:airline#themes#solarized16#palette.visual = airline#themes#generate_color_map(
        \ [s:V1[0].g, s:V1[1].g, s:V1[0].t, s:V1[1].t, s:V1[2]],
        \ [s:V2[0].g, s:V2[1].g, s:V2[0].t, s:V2[1].t, s:V2[2]],
        \ [s:V3[0].g, s:V3[1].g, s:V3[0].t, s:V3[1].t, s:V3[2]])

  let g:airline#themes#solarized16#palette.visual.airline_warning =
        \ g:airline#themes#solarized16#palette.normal.airline_warning

  let g:airline#themes#solarized16#palette.visual_modified = {
        \ 'airline_c': [s:VM[0].g, s:VM[1].g,
        \ s:VM[0].t, s:VM[1].t, s:VM[2]]}

  let g:airline#themes#solarized16#palette.visual_modified.airline_warning =
        \ g:airline#themes#solarized16#palette.normal.airline_warning

  let g:airline#themes#solarized16#palette.replace = airline#themes#generate_color_map(
        \ [s:R1[0].g, s:R1[1].g, s:R1[0].t, s:R1[1].t, s:R1[2]],
        \ [s:R2[0].g, s:R2[1].g, s:R2[0].t, s:R2[1].t, s:R2[2]],
        \ [s:R3[0].g, s:R3[1].g, s:R3[0].t, s:R3[1].t, s:R3[2]])

  let g:airline#themes#solarized16#palette.replace.airline_warning =
        \ g:airline#themes#solarized16#palette.normal.airline_warning

  let g:airline#themes#solarized16#palette.replace_modified = {
        \ 'airline_c': [s:RM[0].g, s:RM[1].g,
        \ s:RM[0].t, s:RM[1].t, s:RM[2]]}

  let g:airline#themes#solarized16#palette.replace_modified.airline_warning =
        \ g:airline#themes#solarized16#palette.normal.airline_warning

  let g:airline#themes#solarized16#palette.tabline = {}

  let g:airline#themes#solarized16#palette.tabline.airline_tab = [
        \ s:I2[0].g, s:I2[1].g, s:I2[0].t, s:I2[1].t, s:I2[2]]

  let g:airline#themes#solarized16#palette.tabline.airline_tabtype = [
        \ s:N2[0].g, s:N2[1].g, s:N2[0].t, s:N2[1].t, s:N2[2]]
endfunction

call airline#themes#solarized16#refresh()

