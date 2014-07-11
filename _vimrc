set nocompatible

let mapleader=","
set tabstop=4
set shiftwidth=4
set nu! "显示行号
syntax enable
syntax on

filetype plugin indent on 

"当保存文件时_vimrc，执行source 

set fileformats =dos
set fileencodings=utf-8,chinese



function! MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

function! MySys()
	if has("win32")
	  return "windows"
	else
	  return "linux"
	endif
endfunction

function! SwitchToBuf(filename)
	
	"find in current tab
	let bufwinnr = bufwinnr(a:filename)
	if bufwinnr != -1
		exec  bufwinnr . "wincmd w"
		return

	else
		"find in each tab
		tabfirst
		let tab = 1
		while tab <= tabpagenr("$")
			let bufwinnr = bufwinnr(a:filename)
			if bufwinnr !=-1
				exec "normal " . tab . "gt"
				exec bufwinnr . "wincmd w"
				return
			endif
			tabnext
			let tab = tab +1
		endwhile
		"not exist , new tab
		exec "tabnew " . a:filename
	endif
endfunction

if MySys() == 'linux'

	map <silent> <leader>ss :source ~/.vimrc<cr>
        "Fast editing of .vimrc
        map <silent> <leader>ee :call SwitchToBuf("~/.vimrc")<cr>
        "When .vimrc is edited, reload it
        autocmd! bufwritepost .vimrc source ~/.vimrc
elseif MySys()=="windows"
	" Set helplang
    	set helplang=cn
   	"Fast reloading of the _vimrc
    	map <silent> <leader>ss :source ~/_vimrc<cr>
    	"Fast editing of _vimrc
    	map <silent> <leader>ee :call SwitchToBuf("~/_vimrc")<cr>
	vmap <C-c> "yy
	vmap <C-x> "yd
	nmap <C-v> "yp
        vmap <C-v> "yp	
	imap <C-s> <Esc>:wa<cr>i<Right>
	nmap <C-s> :wa<cr>
    	"When _vimrc is edited, reload it
    	autocmd! bufwritepost _vimrc source ~/_vimrc
endif

if MySys() == 'windows'
   source $VIMRUNTIME/vimrc_example.vim
   source $VIMRUNTIME/mswin.vim
   behave mswin
endif 


set diffexpr=MyDiff()



""""""""""""""""""""""""""""""""""""""""""""
set sessionoptions-=curdir
set sessionoptions+=sesdir 
set sessionoptions+=slash
set sessionoptions+=unix
let g:AutoSessionFile="project.vim"
let g:OrigPwd = getcwd()


	
autocmd VimEnter * call EnterHandler()
autocmd VimLeave * call LeaveHandler()


function! LeaveHandler()
	if filereadable(g:OrigPwd."/".g:AutoSessionFile)
		exec  "mks! ".g:OrigPwd."/".g:AutoSessionFile
	endif
	
endfunction

function! EnterHandler()
	if filereadable(g:AutoSessionFile)
		exe "source ".g:AutoSessionFile
	endif
endfunction



"""""""""""""""""""""""""""""""""""""""""""
set tags=tags;,E:/Python34/tags
set autochdir
