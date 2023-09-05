--[[

=====================================================================
==================== READ THIS BEFORE CONTINUING ====================
=====================================================================

Kickstart.nvim is *not* a distribution.

Kickstart.nvim is a template for your own configuration.
  The goal is that you can read every line of code, top-to-bottom, understand
  what your configuration is doing, and modify it to suit your needs.

  Once you've done that, you should start exploring, configuring and tinkering to
  explore Neovim!

  If you don't know anything about Lua, I recommend taking some time to read through
  a guide. One possible example:
  - https://learnxinyminutes.com/docs/lua/


  And then you can explore or search through `:help lua-guide`
  - https://neovim.io/doc/user/lua-guide.html


Kickstart Guide:

I have left several `:help X` comments throughout the init.lua
You should run that command and read that help section for more information.

In addition, I have some `NOTE:` items throughout the file.
These are for you, the reader to help understand what is happening. Feel free to delete
them once you know what you're doing, but they should serve as a guide for when you
are first encountering a few different constructs in your nvim config.

I hope you enjoy your Neovim journey,
- TJ

P.S. You can delete this when you're done too. It's your config now :)
--]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '


require "user.plugins"
require "user.options"
require "user.keymaps"
require "user.cmp"
require "user.telescope"

-- Autocommand that reloads -- Autocommand that reloads neovim whenever you save the keymaps.lua file
vim.cmd [[
  augroup keymaps_user_config
    autocmd!
    autocmd BufWritePost keymaps.lua source <afile>
  augroup end
]]


-- Autocommand that reloads neovim whenever you save the options.lua file
vim.cmd [[
  augroup options_user_config
    autocmd!
    autocmd BufWritePost options.lua source <afile>
  augroup end
]]


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



-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require("nvim-treesitter.install").prefer_git = true
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'typescript', 'vimdoc', 'vim' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })

 local lsp_format_modifications = require"lsp-format-modifications"
  lsp_format_modifications.attach(_, bufnr, { format_on_save = false })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
      diagnostics = { globals = { 'vim' } },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}


-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
--
vim.cmd([[

" split windows vertically when termdebug is intitiated
let g:termdebug_wide=1

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

:syntax enable


:command! Bd bp|bd #

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
