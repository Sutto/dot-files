" Use the best font ever.
set guifont=Inconsolata-g:h12.20

" No toolbar
set guioptions-=T

" Correct sizes etc.
set fuoptions=maxvert,maxhorz
set lines=50
set columns=80

" Bind command-/ to toggle comments.
nmap <D-/> ,c<space>
vmap <D-/> ,c<space>
imap <D-/> <C-O>,c<space>
let NERDShutUp = 1 " so it doesn't complain about types it doesn't know

" Command-] will shift left
nmap <D-]> >>
vmap <D-]> >>
imap <D-]> <C-O>>>


" Command-[ will shift right
nmap <D-[> <<
vmap <D-[> <<
imap <D-[> <C-O><<

" bind command-option-l to toggle line numbers
nmap <silent> <D-M-l> :set invnumber<CR>
 
" open tabs with command-<tab number>
map <silent> <D-1> :tabn 1<CR>
map <silent> <D-2> :tabn 2<CR>
map <silent> <D-3> :tabn 3<CR>
map <silent> <D-4> :tabn 4<CR>
map <silent> <D-5> :tabn 5<CR>
map <silent> <D-6> :tabn 6<CR>
map <silent> <D-7> :tabn 7<CR>
map <silent> <D-8> :tabn 8<CR>
map <silent> <D-9> :tabn 9<CR>

