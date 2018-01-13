" Customize which :AirlineTheme to use for specific colorscheme's based on
" caller-supplied mapping table.

" -------------------------------------------------------------------------
" CONFIGURATION:
"
" * Dict providing the mapping table of colorscheme -> airline theme
"   overrides >
"   let g:colorscheme_airlinetheme_map = { ... }
"
" * Default airline theme to use when no specific entry found in the
"   mapping table [and no airline theme which exactly matches current
"   colorscheme] >
"   let g:colorscheme_airlinetheme_default = [str]
" -------------------------------------------------------------------------

" Use a ColorScheme autocmd to automatically switch :AirlineTheme based on
" the new colorscheme.  Defer adding the ColorScheme autocmd until the
" VimEnter event so that our ColorScheme autocmd hook will be 'last' in the
" 'autocmd ColorScheme' stack.
augroup airlinetheme_map_afterinit
  autocmd!
  autocmd VimEnter * silent! call <SID>on_init()
augroup END

function! s:on_init()
  augroup airlinetheme_map
    autocmd!
    autocmd ColorScheme * call <SID>on_colorscheme_change()
  augroup END
  call <SID>on_colorscheme_change()
endfunction

function! s:on_colorscheme_change()
  " if there's an AirlineTheme override for this colorscheme, use that
  if exists('g:colorscheme_airlinetheme_map') &&
        \ has_key(g:colorscheme_airlinetheme_map, g:colors_name)
    let g:airline_theme=g:colorscheme_airlinetheme_map[g:colors_name]
    :AirlineRefresh
  else
    " if there's an exact-match AirlineTheme for the current colorscheme,
    " use that; else use the user-defined default AirlineTheme (if any)
    if exists('g:colorscheme_airlinetheme_default') &&
          \ g:airline_theme != g:colors_name
      let g:airline_theme=g:colorscheme_airlinetheme_default
      :AirlineRefresh
    endif
  endif
endfunction
