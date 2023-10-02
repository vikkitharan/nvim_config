-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.cmd([[

" split windows vertically when termdebug is intitiated
let g:termdebug_wide=1

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

:command! -nargs=1 SFiles call SearchFiles(<q-args>)
:command! -nargs=1 SBuffers call SearchBuffers(<q-args>)
:command! -nargs=1 Open call OpenFile(<q-args>)
:command! -nargs=0 Ls call DispBuffers()
:command! -nargs=0 Ds call DeleteBuffers()
:command! -nargs=1 SFileList call ArgFiles(<q-args>)
:command! -nargs=0 CloseArgs call CloseArgFiles()
:command! -nargs=0 GdbBtArrange call GdbBtRearrange()
:command! -nargs=0 SParents call SearchParents()
:command! -nargs=0 OpenSearchFile call OpenSearchFile()

:let buflist = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']
:let vimcount = system("pgrep vim | wc -l")
:let vimcount = vimcount - 1
let g:Base = buflist[vimcount]
let g:FileNo = 0
let g:SearchPatterns = {}


autocmd FileType c map <buffer> <C-B> :py3f /usr/share/vim/addons/syntax/clang-format.py<cr>
autocmd FileType c imap <buffer> <C-B> <c-o>:py3f /usr/share/vim/addons/syntax/clang-format.py<cr>

autocmd FileType python map <buffer> <C-B> :! autopep8 --in-place --aggressive --aggressive  % <cr>

autocmd Filetype gitcommit setlocal spell textwidth=72

:autocmd FileType python set equalprg=yapf

function! GdbBtRearrange()
  :exe '%s/\n\(#\)\@!/\1/g'
  :exe '%s/^#\d\+.\{-\}in //g'
  :exe '%s/^\(.*\) at \(.*\)/\2: \1/g'
  :exe '%! tac'
  :exe 'w'
endfunction


function! SearchBuffers(pattern )
  let bl=''
  :bufdo let bl=bl.' '.expand('%')
  if a:pattern[0] == "\""
    let pattern = strpart(a:pattern,1,len(a:pattern)-2)
  else
    let pattern = a:pattern
  endif
  if strpart(pattern, len(pattern)-2, 2) == "\\c"
    :exe "! grep -in \'".strpart(pattern,0,len(pattern)-2)."\' ".bl." > /tmp/S".g:Base.g:FileNo.""
  else
    :exe "! grep -n \'".pattern."\' ".bl." > /tmp/S".g:Base.g:FileNo.""
  endif
  exe ":e /tmp/S".g:Base.g:FileNo.""
  let b:search = pattern
  let @/ = b:search
  let g:FileNo += 1
  if g:FileNo == 10
    let g:FileNo = 0
  endif
endfunction

function! SearchFiles(pattern)
  if a:pattern[0] == "\""
    let pattern = strpart(a:pattern,1,len(a:pattern)-2)
  else
    let pattern = a:pattern
  endif
  let FileNo = g:FileNo

  if strpart(pattern, len(pattern)-2, 2) == "\\c"
    exe ":! cat ".g:FileName." | xargs grep -in \'".strpart(pattern,0,len(pattern)-2)."\' > /tmp/S".g:Base.FileNo.""
  else
    exe ":! cat ".g:FileName." | xargs grep -n \'".pattern."\' > /tmp/S".g:Base.FileNo.""
  endif
  exe ":e /tmp/S".g:Base.FileNo.""
  let b:search = pattern
  let @/ = b:search

  if FileNo == g:FileNo
  "New output file is used
    let g:SearchPatterns[FileNo] = pattern
    let g:FileNo += 1
    if g:FileNo == 10
      let g:FileNo = 0
    endif
  endif
endfunction

function! ArgFiles(pattern)
  if a:pattern[0] == "\""
    let pattern = strpart(a:pattern,1,len(a:pattern)-2)
  else
    let pattern = a:pattern
  endif
  if strpart(pattern, len(pattern)-2, 2) == "\\c"
    exe ":! cat ".g:FileName." | xargs grep -il \'".strpart(pattern,0,len(pattern)-2)."\' > /tmp/Stemp"
  else
    exe ":! cat ".g:FileName." | xargs grep -l \'".pattern."\' > /tmp/Stemp"
  endif
  exe ":ar `cat /tmp/Stemp`"
  let @/ = pattern
endfunction

function! CloseArgFiles()
  let Files = readfile("/tmp/Stemp")
  if len(Files) > 1
    for File in Files
      exe ":bw ".File.""
    endfor
  endif
  exe ":! echo -n \"\" > /tmp/Stemp"
endfunction

function! DispBuffers( )
  for i in g:NoDispBuf
    let name = bufname(i)
    let name = fnamemodify(name, ":t")
    echo i." ".name
  endfor
endfunction

function! OpenFile(pattern)
  if a:pattern[0] == "\""
    let pattern = strpart(a:pattern,1,len(a:pattern)-2)
  else
    let pattern = a:pattern
  endif
  if strpart(pattern, len(pattern)-2, 2) == "\\c"
    exe ":!grep -i \'".strpart(pattern,0,len(pattern)-2)."\' ".g:FileName." > /tmp/aatmp"
  else
    exe ":!grep \'".pattern."\' ".g:FileName." > /tmp/aatmp"
  endif
  let FileLst = readfile('/tmp/aatmp')
  let nooffiles = len(FileLst)
  if nooffiles == 1
    exe ":e ".FileLst[0].""
  elseif nooffiles == 0
    echo "No file found!"
  elseif nooffiles > 1
    call insert(FileLst, "Select a file:")
    for i in range(1,len(FileLst)-1)
      let FileLst[i] = i." ".FileLst[i]
    endfor
    let index = -1
    while !((index >= 0) && (index < len(FileLst)))
      let index = inputlist(FileLst)
      echo "\n\n"
    endwhile
    if ( index > 0 )
      let file = substitute(FileLst[index],'^[0-9]\+ ','','g')
      exe ":e ".file.""
    endif
  endif
endfunction

let g:NoDispBuf = []

function! MyTabLine()
  let l:buflst = []
  for i in range(bufnr('$'))
    if buflisted(i+1) == 1
      let l:buflst += [i+1]
    endif
  endfor

  let s = ''
  let fmtstrlen = 0
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
      let fmtstrlen += 13
    else
      let s .= '%#TabLine#'
      let fmtstrlen += 10
    endif

    let buflist = tabpagebuflist(i+1)
    let winnr = tabpagewinnr(i+1)
    let idx = index(l:buflst, buflist[winnr -1])
    if idx != -1
      let a = remove(l:buflst, idx)
    endif
    let name = bufname(buflist[winnr - 1])
    let name = fnamemodify(name,":t")

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'
    let fmtstrlen += strlen(i+1) + 2
    "let s .= (i+1) . name . ' '
    let s .= name . ' '

  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'
  let fmtstrlen += 16
  let s .= ' | '

  let winwidth = 0
  for i in range(winnr('$'))
    let winwidth += winwidth(i)
  endfor
  let cnt = 0
  let g:NoDispBuf = []
  let bufNames = []
  let bufnamelen = 0
  let TabLnLen = strlen(s) - fmtstrlen
  for i in l:buflst
    let name = bufname(i)
    let name = fnamemodify(name, ":t")
    "let dispname = " " .  name . i
    let dispname = name . " " . i
    if ( ( strlen(dispname) -strlen(i) + TabLnLen + bufnamelen + 5 ) < winwidth )
      let bufNames += [dispname]
      let bufnamelen += strlen(dispname) -strlen(i)
    else
      let cnt += 1
      let g:NoDispBuf += [i]
    endif
  endfor
  call sort(bufNames)
  let i = 0
  for name in bufNames
    let pos = stridx(name, " ")
    let s .= '%' . strpart(name,pos+1) . 'T'
    if i == 0
      "let s .= '%#Search#'
      let s .= '%#TabLineFill#'
    else
      let s .= '%#StatusLine#'
    endif
    let s .= strpart(name,0,pos+1)
    let i = 1 - i
  endfor

  let s .= '%#TabLineFill#%T'

  if cnt > 0
    let s .= " " . cnt
  endif

  " right-align the label to close the current tab page
  "  if tabpagenr('$') > 1
  "    let s .= '%=%#TabLine#%999XXX'
  "  endif
  let s .= '%=%#TabLine#%999XXX'

  return s
endfunction


:set tabline=%!MyTabLine()
let $PAGER=''

"----------------------- Abbreiviations ------------------"


"======================= folding =================="
":set foldcolumn=4 " extra 4 columns added at front to show details of folding
:command! -nargs=1 ICF exe "normal! mz gg" | call IfCodeFolding(<q-args>) | "normal! `z"
function! IfCodeFolding(pattern)
  let line1 = line(".")
  if matchstr(a:pattern,"#if") != "#if"
    try
      exe "/[^#]".a:pattern.""
    endtry
    exe "normal! ma"
    exe "/{"
  else
    try
      exe "/". a:pattern
    endtry
    exe "normal! ma"
  endif
  exe "normal! %"
  let line2 = line(".")
  if ( line2 > line1)
    exe "normal! zf`a j"
    call IfCodeFolding(a:pattern)
  endif
endfunction

:nmap {} :call CodeFolding()<CR>
function! CodeFolding()
  exe "normal! ma % zf`a"
endfunction

"-------------------vimdiff--------------------"
"set diffopt+=iwhite



function! Restore_search()
	if exists("b:search")
	  let @/ = b:search
	endif
endfunction

autocmd  BufEnter  /tmp/S[a-z][0-9]   : call Restore_search()

function! SearchParents()

let lines = getline(1, "$")
python3 << EOF

import vim
import subprocess

def get_function(func_data_file, file_name, num):
  file_offset = 0
  num_lines = 0
  func_name = ""
  line_num = int(num)

  with open(func_data_file) as f:
    num_files = int(f.readline())

    for i in range(num_files):
      line = f.readline()
      file_data = line.split()
      if (file_data[0] == file_name):
        file_offset = int(file_data[1])
        num_lines = int(file_data[2])
        break

    if (file_offset != 0):
      f.seek(file_offset)
      """Parent function is defined just above the requested line_num"""
      for i in range(num_lines):
        line = f.readline()
        file_data = line.split()
        current_line_num = int(file_data[0])
        if (current_line_num > line_num):
          break
        if (current_line_num != line_num):
          func_name = file_data[1]

    f.closed
  return func_name

buf_lines = vim.eval('lines')
project_file = vim.eval('g:FileName')
func_data_file = project_file.replace("files_", "func_").replace(".txt", "")
parents = []
subprocess.check_call(['rm', '-f', '/tmp/parents_output'])
for line in buf_lines:
  line_number = line.split(":")
  if len(line_number) >= 2:
    func = get_function(func_data_file, line_number[0], line_number[1])
    if len(func) > 0 and func not in parents:
      with open('/tmp/parents_output', 'a') as outstream:
        subprocess.check_call(['echo', '-e', "\n{0:s}\n".format(func)], stdout=outstream)
      catproc = subprocess.Popen(['cat', project_file], stdout=subprocess.PIPE)
      grepproc = subprocess.Popen(['xargs', 'grep', '-n', func],
          stdin=catproc.stdout,
          stdout=open("/tmp/parents_output", "a"))
      grepproc.communicate()
      parents.append(func)
vim.command("let parents_vim = %s" % parents)
EOF

exe ":! mv /tmp/parents_output /tmp/S".g:Base.g:FileNo.""
exe ":e /tmp/S".g:Base.g:FileNo.""
"let b:search = pattern
"let @/ = b:search
let g:FileNo += 1
if g:FileNo == 10
  let g:FileNo = 0
endif

endfunction

function! OpenSearchFile( )
  let FileLst = []
  let SearchString = []
  for [key, value] in items(g:SearchPatterns)
    call add(FileLst, "/tmp/S".g:Base.key)
    call add(SearchString, value)
  endfor
  let nooffiles = len(FileLst)
  if nooffiles == 1
    exe ":e ".FileLst[0].""
  elseif nooffiles > 1
    let PromptLst = []
    for i in range(len(FileLst))
      call add(PromptLst, i." ".FileLst[i]." ".SearchString[i])
    endfor
    call insert(PromptLst, "Select a file:")
    let index = -1
    let index = inputlist(PromptLst)
    exe ":e ".FileLst[index].""
  endif
endfunction

"-------------------Project space------------------"

:command! -nargs=1 SetProject call SetProject(<q-args>)


function! SetProject(pattern)
let &tag = "tags_" . a:pattern
let g:FileName = "files_" . a:pattern . ".txt"
endfunction


function! CProject()
  exe '! find -type f -name "*.d" | xargs cat | ~/.ProjFiles.sh > files.txt'
  exe '! ctags -L files.txt'
endfunction

function! DumpProject()
  exe '! find -type f -not -path "./.git/*" > files.txt '
  exe '! ctags -L files.txt'
endfunction
"------------------- Developing features------------------"
function! Test()
  exe '! clear '
  exe '! find -type f -name "*.d" | xargs cat | ~/.ProjFiles.sh > .files.txt '
  exe '! find -name ".files.txt" '
  exe '! ctags -L .files.txt '
endfunction


function! DeleteBuffers( )
  for buf in getbufinfo({'buflisted':1})
    let name = fnamemodify(buf.name, ":t")
    echo buf.bufnr . " " . name
  endfor
  let files = input("Select files to close: ")

"Use python for string to list with split()
python3 << EOF
import vim
files = vim.eval('files').split()
vim.command("let files = %s" % files)
EOF

  for i in files
    :exe "b " . i
    :exe "bd " . i
  endfor
endfunction

  ]]
)
