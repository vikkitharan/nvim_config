local ok, conform = pcall(require, 'conform')
if not ok then return end

conform.setup {
  -- Conform runs whatever is on PATH (Mason or manual installs).
  -- This table only says which tool to use for which filetype.
  formatters_by_ft = {
    c      = { 'clang-format' }, -- picks up the project's .clang-format
    cpp    = { 'clang-format' },
    python = { 'black' },
    javascript = { 'prettier' },
    json       = { 'prettier' },
    lua        = { 'stylua' },
    -- uncomment after :MasonInstall shfmt
    -- sh   = { 'shfmt' },
    -- bash = { 'shfmt' },
  },
  -- any other filetype: use the LSP formatter if one is attached
  default_format_opts = { lsp_format = 'fallback', timeout_ms = 2000 },
}

local diff = (vim.text and vim.text.diff) or vim.diff -- vim.diff is deprecated in 0.12

-- Contents of the file as committed in HEAD, or nil when the file is not in HEAD
-- (untracked, staged-but-never-committed, not in a repo, or repo with no commits).
local function head_lines(file)
  local dir, name = vim.fs.dirname(file), vim.fs.basename(file)
  local out = vim.fn.systemlist { 'git', '-C', dir, 'show', 'HEAD:./' .. name }
  if vim.v.shell_error ~= 0 then return nil end
  return out
end

-- Format only the lines that differ from HEAD, bottom-up so line numbers stay valid.
local function format_changed(bufnr, old_lines)
  if vim.bo[bufnr].fileformat == 'dos' then
    old_lines = vim.tbl_map(function(l) return (l:gsub('\r$', '')) end, old_lines)
  end
  local new_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local old = #old_lines > 0 and (table.concat(old_lines, '\n') .. '\n') or ''
  local new = table.concat(new_lines, '\n') .. '\n'

  local hunks = diff(old, new, { result_type = 'indices' })
  for i = #hunks, 1, -1 do
    local _, _, start_b, count_b = unpack(hunks[i])
    if count_b > 0 then -- skip pure deletions
      local last = start_b + count_b - 1
      local text = vim.api.nvim_buf_get_lines(bufnr, last - 1, last, false)[1] or ''
      conform.format {
        bufnr = bufnr,
        range = { start = { start_b, 0 }, ['end'] = { last, #text } },
      }
    end
  end
end

vim.api.nvim_create_autocmd('BufWritePre', {
  group = vim.api.nvim_create_augroup('AutoFormat', { clear = true }),
  callback = function(args)
    local buf = args.buf
    if vim.g.disable_autoformat or vim.b[buf].disable_autoformat then return end
    if vim.wo.diff then return end -- git difftool buffers
    if vim.bo[buf].buftype ~= '' or not vim.bo[buf].modifiable then return end
    local file = vim.api.nvim_buf_get_name(buf)
    if file == '' then return end

    local old = head_lines(file)
    if old then
      format_changed(buf, old)       -- in HEAD: changed lines only
    else
      conform.format { bufnr = buf } -- not in HEAD: whole file
    end
  end,
})

vim.api.nvim_create_user_command('FormatToggle', function()
  vim.g.disable_autoformat = not vim.g.disable_autoformat
  vim.notify('Autoformat ' .. (vim.g.disable_autoformat and 'OFF' or 'ON'))
end, {})

-- manual: whole file in normal mode, selection in visual mode
vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
  conform.format { async = true }
end, { desc = 'Format file/selection' })
