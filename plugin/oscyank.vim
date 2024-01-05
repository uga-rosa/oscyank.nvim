if exists('g:loaded_oscyank_nvim')
  finish
endif
let g:loaded_oscyank_nvim = 1

command! -nargs=1 OscYank call oscyank#yank(<q-args>)
command! -register OscYankRegister call oscyank#yank_register(<q-reg>)

nnoremap <expr> <Plug>(oscyank) oscyank#yank_operator()
xnoremap <silent> <Plug>(oscyank) :call oscyank#yank_visual()<CR>
