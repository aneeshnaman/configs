" BOOTSTRAP
""""""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible

" Vundle plugin manager
" This needs to be before sourcing google.vim otherwise runtimepath will be
" messed up.
filetype off  " Required!
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" Self-manage Vundle. Required.
Plugin 'gmarik/vundle'
" Other vundle plugins
Plugin 'wesQ3/vim-windowswap'
Plugin 'wincent/command-t'
Plugin 'SirVer/ultisnips'
"Plugin 'google/vim-syncopate'
call vundle#end()

set rtp+=~/.fzf


" BASICS
""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
filetype plugin indent on
set ruler
set hlsearch
set number
set ignorecase
set smartcase
set scrolloff=10
set expandtab
set autoindent
set showcmd
" Match angular braces for proto outputs
set matchpairs+=<:>
set wildmode=longest,list
set smarttab
set gdefault
set showmatch
set autoread

let mapleader = ","

" Vim detects *.md files as modula2. So fix this.
autocmd BufNewFile,BufReadPost *.md setlocal filetype=markdown



" NAVIGATION
""""""""""""""""""""""""""""""""""""""""""""""""""""

" go to next/previous lines on movement
set whichwrap=b,s,h,l

" scroll multiple lines on C-Y and C-E, default is too slow
nnoremap <c-y> 
nnoremap <c-e> 

" ignore case while completing filenames
set wildignorecase
set fileignorecase

" Navigate tabs using Alt-1/2/3/..
noremap <A-F1> :tabn 1<cr>
noremap <A-F2> :tabn 2<cr>
noremap <A-F3> :tabn 3<cr>
noremap <A-F4> :tabn 4<cr>
inoremap <A-F1> <ESC> :tabn 1<cr>
inoremap <A-F2> <ESC> :tabn 2<cr>
inoremap <A-F3> <ESC> :tabn 3<cr>
inoremap <A-F4> <ESC> :tabn 4<cr>

" Switch windows faster
nmap <c-k> <c-w>k<c-w>_
nmap <c-j> <c-w>j<c-w>_
nmap <c-h> <c-w>h
nmap <c-l> <c-w>l

" Maximize current window size vertically
set winheight=10
set wmh=5

set winwidth=86
set winminwidth=20
autocmd FileType cpp set winwidth=86
autocmd FileType python set winwidth=86
autocmd FileType java set winwidth=106

" Jump the last position in the file on re-opening
:au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

noremap [[ ?{<CR>w99[{
noremap ][ /}<CR>b99]}
noremap ]] j0[[%/{<CR>
noremap [] k$][%?}<CR>

" Switch between .h / -inl.h / .cc / .py / .js / _test.* / _unittest.* with ,h
let pattern = '\(\(_\(unit\)\?test\)\?\.\(cc\|cpp\|js\|py\)\|\(-inl\)\?\.h\)$'
nmap ,cc :e <C-R>=substitute(expand("%"), pattern, ".cc", "")<CR><CR>
nmap ,h :e <C-R>=substitute(expand("%"), pattern, ".h", "")<CR><CR>
nmap ,i :e <C-R>=substitute(expand("%"), pattern, "-inl.h", "")<CR><CR>
nmap ,t :e <C-R>=substitute(expand("%"), pattern, "_test.", "") . substitute(expand("%:e"), "h", "cc", "")<CR><CR>
nmap ,B :e %:h/BUILD<CR>

autocmd FileType java nmap <buffer> ,t :e <C-R>=substitute(substitute(expand("%"), 'java/com/google', 'javatests/com/google', ""), '.java', "Test.java", "")<CR><CR>
autocmd FileType java nmap <buffer> ,j :e <C-R>=substitute(substitute(expand("%"), 'javatests/com/google', 'java/com/google', ""), 'Test.java', ".java", "")<CR><CR>

" open current file in codesearch
nnoremap <leader>cs :execute '!google-chrome https://cs/\#piper///depot/google3/' . substitute(expand("%:p"), "^.*google3\/", "", "") . '\&l=' . line(".")<cr><cr>
" search current word/WORD in codesearch
nnoremap <leader>cw :execute '!google-chrome https://cs/' . expand('<cword>')<cr><cr>
nnoremap <leader>cW :execute '!google-chrome https://cs/' . expand('<cWORD>')<cr><cr>

" Invoke FZF in command line. First <CR> to paste result, second <CR> to execute the command.
cnoremap <Leader>ff <C-R>=fzf#run({'down': '40%'})<CR><CR>


" DISPLAY
""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
colorscheme desert

" In smaller screens we increase the window width while jumping into it. So
" wrapping is not required since the current window is always the right width
" (at least for code windows 80 chars).
autocmd FileType cpp,java,borg set nowrap
autocmd FileType cpp,java set listchars+=precedes:<,extends:>

set display=lastline
set noequalalways
set guifont=Courier\ New\ 12

" Cursorline looks nice
autocmd WinLeave * setlocal nocursorline
autocmd WinEnter * setlocal cursorline
autocmd BufLeave * setlocal nocursorline
autocmd BufEnter * setlocal cursorline

hi StatusLine ctermbg=black
hi StatusLineNC ctermbg=black
hi TabLineSel ctermfg=yellow

" always show the status line
set laststatus=2

" Folding
set foldmethod=indent
set foldlevelstart=99
nnoremap <silent> <Space> @=(foldlevel('.')?'zA':'l')<CR>

" Highlight lines longer than 80 chars
" http://wiki.corp.google.com/twiki/bin/view/Main/VimTips
function! HighlightTooLongLines(len)
  highlight def link RightMargin Error
  if &textwidth != 0
    exec 'match RightMargin /\%<' . (&textwidth + 3) . 'v.\%>' . (&textwidth + 1) . 'v/'
    let &colorcolumn = a:len + 1
    highlight ColorColumn ctermbg=black ctermfg=red
  endif
endfunction
au WinEnter,BufEnter,BufNewFile,BufRead *.cc,*.h,*.proto call HighlightTooLongLines(80)
au WinEnter,BufEnter,BufNewFile,BufRead *.java call HighlightTooLongLines(100)

" keep quickfix window height to number of results
au FileType qf call AdjustWindowHeight(3, 50)
function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$")+1, a:maxheight]), a:minheight]) . "wincmd _"
endfunction

" set titlestring to the current g4 client and the filename
set title
autocmd BufEnter * let &titlestring = expand("%:t")

" Override the google3 defaults
hi Constant ctermfg=3
hi Search term=bold ctermbg=3 ctermfg=20

" Show the GCL hierarchy in .borg files in the status line
autocmd WinLeave * setlocal statusline=
autocmd BufLeave * setlocal statusline=
"autocmd WinEnter *borg setlocal statusline=%!GCLHierarchy()
"autocmd BufEnter *borg setlocal statusline=%!GCLHierarchy()

" Returns the GCL hierarchy of the current cursor position
function! GCLHierarchy()
python << endpython
import vim, re, string
(row, col) = vim.current.window.cursor
buf = vim.current.buffer[0:row]
context = []
for line in buf:
  match = re.match(r'([a-zA-Z0-9_ ]*).*{\s*', line)
  if match:
    words = match.group(1).split()
    context.append(words[-1])
  elif re.match(r'\s*}\s*', line):
    context.pop()
vim.command("let ctx = '%s'" % string.join(context, "."))
endpython
return ctx
endfunction

" Change search highlight to black over yellow
" (default is white over yellow which is not visible)
highlight Search ctermfg=0 ctermbg=3




" SHORTCUTS
""""""""""""""""""""""""""""""""""""""""""""""""""""

" go up/down in visual lines, not file lines
nnoremap j gj
nnoremap k gk
" quick escape to normal mode
inoremap jk <esc>
" match parens with tab
nnoremap <tab> %
vnoremap <tab> %

" move to first char: its more common to move to the first actual char than the
" start of line
nnoremap 0 ^
nnoremap ^ 0

" Save all files. Also prevents again accidentally doing :wq instead of :wa.
nnoremap <leader>ss :wa<cr>

" Shift+Insert -> Paste from the X11 PRIMARY selection
" Ctrl-V       -> Paste from the X11 CLIPBOARD
" See :help x11-selection and :help registers
" NOTE: shift+insert is normally captured by the terminal program. So to get
" this to work, we disable this in .mrxvtrc. Hence this mapping will work only
" on our mrxvt. For other places use <c-r><c-o>* manually
inoremap <S-Insert> <C-r><C-o>*
inoremap <C-insert> <esc>"+pa
cnoremap <S-Insert> <C-r>*

" edit and source vimrc
nnoremap <leader>ev :split $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" quick remove search highlight
nnoremap <leader><space> :noh<cr>

autocmd FileType vim let b:comment_leader = '" '
autocmd FileType c,cpp,java let b:comment_leader = '// '
autocmd FileType sh,make let b:comment_leader = '# '
nnoremap <silent> <leader>C :<C-B>sil <C-E>s/^/<C-R>=escape(b:comment_leader,'\/')<CR>/<CR>:noh<CR>
nnoremap <silent> <leader>U :<C-B>sil <C-E>s/^\V<C-R>=escape(b:comment_leader,'\/')<CR>//e<CR>:noh<CR>

nnoremap <leader>fl :FormatLines<CR>
vnoremap <leader>fl :FormatLines<CR>
" updates all lines which is a problem in code reviews, so use sparingly
nnoremap <leader>ff :FormatCode<CR>
autocmd BufWritePre *.cc :ClangFormat
autocmd BufWritePre *.h :ClangFormat

nnoremap \t :CommandT<cr>

" Uppercase word under cursor using Alt-u.
" The mapping is actually for <esc-u>, because linux terminals actually send
" esc-x for alt-x. http://vim.wikia.com/wiki/VimTip738
inoremap <c-U> <esc>mxviwU`xa
nnoremap u mxviwU`x

" nsp -> namespace
autocmd FileType cpp :iab nsp namespace

" Add build rules
function! s:CCLib(name)
  execute "normal icc_library(\nname = \"" . a:name . "\",\nsrcs = [\"" . a:name . ".cc\"],\nhdrs = [\"" . a:name . ".h\"],\ndeps = [\n],\n)\n"
endfunction
command! -nargs=1 CCLib call s:CCLib(<args>)

function! s:CCTest(name)
  execute "normal icc_test(\nname = \"" . a:name . "_test\",\nsrcs = [\"" . a:name . "_test.cc\"],\ndeps = [\n\":" . a:name . "\",\n\"//testing/base/public:gunit_main\",\n],\n)\n"
endfunction
command! -nargs=1 CCTest call s:CCTest(<args>)

" Better brace completion in CC files
" Adds ; after classes
" Adds // namespace <foo> after namespaces
autocmd BufRead,BufNewFile *.cc,*.h,*.java imap <buffer> {<CR> {<CR><ESC>:call SmartBraceComplete()<CR>O
function! SmartBraceComplete()
 if getline(line('.') - 1) =~ '^\s*\(class\|struct\)'
   normal i};
   return
 endif

 if getline(line('.') - 1) =~ '^\s*namespace.*'
   let nsp = matchstr(getline(line('.') - 1), '^\s*namespace\s*\zs.\{-}\ze\s*{')
   if empty(nsp)
     execute "normal i}  // namespace"
   else
     execute "normal i}  // namespace " . nsp
   endif
 else
     execute "normal i}"
 endif
endfunction

" Fixes filename lines yanked from gtags list to #includes
function! Includize()
  exe ":s/^/#include \"/"
  exe ":s/|.*/\"/"
  exe ":silent! s/\.proto\"/.proto.h\"/"
endfunction
nmap ,I :call Includize()<CR>

" Sort selected lines
vmap <leader>s :sort<CR>
" Sort this block
nnoremap <leader>sb vip:sort<CR>

" Open file in the same directory as the current file.
nnoremap <expr> <leader>csp ':sp ' . expand('%:h') . '/'




" OTHER PLUGINS
""""""""""""""""""""""""""""""""""""""""""""""""""""




" MISCELLANEOUS
""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap zz zz15<C-E>

" Show GOOGLE in logo colors in any file
""""""""""""""""""""""""""""""""""""""""""""""""""""
function! ColorGoogle()
  highlight googleG0 ctermfg=blue guifg=blue
  highlight googleO0 ctermfg=red guifg=red
  highlight googleO1 ctermfg=yellow guifg=yellow
  highlight googleG1 ctermfg=blue guifg=blue
  highlight googleL ctermfg=green guifg=green
  highlight googleE ctermfg=red guifg=red

  syn match googleG0 /[Gg]\(oogle\)\@=/ containedin=ALL display
  syn match googleO0 /\([Gg]\)\@<=o\(ogle\)\@=/ containedin=ALL display
  syn match googleO1 /\([Gg]o\)\@<=o\(gle\)\@=/ containedin=ALL display
  syn match googleG1 /\([Gg]oo\)\@<=g\(le\)\@=/ containedin=ALL display
  syn match googleL /\([Gg]oog\)\@<=l\(e\)\@=/ containedin=ALL display
  syn match googleE /\([Gg]oogl\)\@<=e/ containedin=ALL display
endfunction

augroup filetypedetect
  au BufNewFile,BufRead * call ColorGoogle()
augroup END
""""""""""""""""""""""""""""""""""""""""""""""""""""

" Disable open-man-page on pressing K
nnoremap K <nop>

" ************************************
" ******** MOVE WINDOWS AROUND *******
" ********        START        *******
" ************************************
let g:markedWinNum = 0
function! MarkWindowSwap()
   let g:markedWinNum = winnr()
endfunction

function! DoWindowSwap()
   if g:markedWinNum == 0
      echom "WindowSwap: No window marked to swap! Mark a window first."
      return
   endif
   "Mark destination
   let curNum = winnr()
   let curBuf = bufnr( "%" )
   exe g:markedWinNum . "wincmd w"
   "Switch to source and shuffle dest->source
   let markedBuf = bufnr( "%" )
   "Hide and open so that we aren't prompted and keep history
   exe 'hide buf' curBuf
   "Switch to dest and shuffle source->dest
   exe curNum . "wincmd w"
   "Hide and open so that we aren't prompted and keep history
   exe 'hide buf' markedBuf
   let g:markedWinNum = 0
endfunction

function! EasyWindowSwap()
   if g:markedWinNum == 0
      call MarkWindowSwap()
   else
      call DoWindowSwap()
   endif
endfunction

if !exists('g:windowswap_map_keys')
   let g:windowswap_map_keys = 1
endif

if g:windowswap_map_keys
   nnoremap <silent> <leader>yw :call MarkWindowSwap()<CR>
   nnoremap <silent> <leader>pw :call DoWindowSwap()<CR>
   nnoremap <silent> <leader>ww :call EasyWindowSwap()<CR>
endif
" ************************************
" ********         END         *******
" ******** MOVE WINDOWS AROUND *******
" ************************************
