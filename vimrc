
" --------------- PREFERENCES -----------------"
:syn on
:set mousehide
:set mousemodel=popup
anoremenu 1.12 PopUp.&Ripristina\ Linea U
anoremenu 1.13 PopUp.&Ripristina <C-R>

" ----------- INDENTING/TABBING ---------------"
:set tabstop=4
:set shiftwidth=4
:set expandtab
:set smarttab
:set softtabstop=4
:set scrolloff=7
:au FileType make   :set noexpandtab "Makefile's are tab-sensitive
filetype indent on 

"-------------- FOLDING ----------------------"
:nnoremap <Space> zA

"-------------- EDITOR SHORTCUTS --------------"

" Fast save shortcuts (Ctrl-s)
:inoremap <C-s> <Esc>:w<Cr>i
:nnoremap <C-s> :w<Cr>

" Link opening
:nnoremap <C-CR>    <C-]>
:nnoremap <C-Backspace> <C-t>

" Navigate between buffers
:nnoremap <C-Tab>    :bn!<CR>
:nnoremap <C-S-Tab>  :bp!<CR>

" Switching between splits
:nnoremap <C-Up>     <C-W><Up>
:nnoremap <C-Down>   <C-W><Down>
:nnoremap <C-Left>   <C-W><Left>
:nnoremap <C-Right>  <C-W><Right>


"-------------- SELECTION SHORTCUTS -------------"

" Moving selections
" Gui Vim
:vnoremap <S-Left>  <gv
:vnoremap <S-Right> >gv

" Enclose selection (both sides)
:vnoremap ( <ESC>`>a)<ESC>`<i(<ESC> 
:vnoremap [ <ESC>`>a]<ESC>`<i[<ESC>
:vnoremap { <ESC>`>a}<ESC>`<i{<ESC> 
:vnoremap < <ESC>`>a><ESC>`<i<<ESC>

:vnoremap ) <ESC>`>a)<ESC>`<i(<ESC>
:vnoremap ] <ESC>`>a]<ESC>`<i[<ESC>
:vnoremap } <ESC>`>a}<ESC>`<i{<ESC> 
:vnoremap > <ESC>`>a><ESC>`<i<<ESC>                                        
 
"Justify selection
:vnoremap <C-j> !fmt -110<CR>


"----------------- EDITING CODE ----------------------"
:inoremap <S-F7> <Esc>:cp<CR>i
:inoremap <F7> <Esc>:cn<CR>i
:inoremap <F8> <Esc>:make<CR>i
:inoremap <F9> <Esc>:make run<CR>i

:nnoremap <S-F7> :cp<CR>
:nnoremap <F7>   :cn<CR>
:nnoremap <F8>   :make<CR>
:nnoremap <F9>   :make run<CR>

" vim: set filetype=vim 
