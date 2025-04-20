set cursorline

syntax on
set encoding=utf8
set number
set mouse=a
set tabstop=4       " number of visual spaces per TAB
set softtabstop=4   " number of spaces in tab when editing
set shiftwidth=4    " number of spaces to use for autoindent
set expandtab       " tabs are space
set autoindent
set copyindent      " copy indent from the previous line
set nowrap
set diffopt+=vertical
set nobackup
set nowritebackup
set cmdheight=1
set signcolumn=yes

set guifont=DroidSansMono\ Nerd\ Font\ 11

let g:airline_powerline_fonts = 1

call plug#begin()
 Plug 'lukas-reineke/indent-blankline.nvim', { 'tag': 'v2.20.8' },
 Plug 'tpope/vim-fugitive',
 Plug 'gbprod/cutlass.nvim',
 Plug 'nvim-lua/plenary.nvim',
 Plug 'kyazdani42/nvim-tree.lua',
 Plug 'nvim-pack/nvim-spectre',
 Plug 'chriskempson/base16-vim',
 Plug 'lewis6991/gitsigns.nvim',
 Plug 'vim-airline/vim-airline',
 Plug 'vim-airline/vim-airline-themes',
 Plug 'numToStr/Comment.nvim',
 Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'},
 Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.6' },
 Plug 'ryanoasis/vim-devicons',
 Plug 'mfussenegger/nvim-dap',
 Plug 'nvim-neotest/nvim-nio',
 Plug 'rcarriga/nvim-dap-ui',
 Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

autocmd BufWritePre *.js,*.ts,*.tsx CocCommand eslint.executeAutoFix

let g:airline#extensions#branch#enabled = 1


inoremap <silent><expr> <c-space> coc#refresh()


" Mostrar menu de ações (como rename, format, etc)
nmap <leader>a <Plug>(coc-codeaction)

" Ir para definição
nmap <leader>d <Plug>(coc-definition)

" Mostrar info de tipo/símbolo
nmap <leader>h :call CocActionAsync('doHover')<CR>


let g:airline_exclude_filetypes = ['NvimTree']


set fillchars+=vert:\│
set fillchars+=horiz:\─


lua << EOF
require("indent_blankline").setup {
  char = "│",
  buftype_exclude = {"terminal"},
  show_trailing_blankline_indent = false,
}
EOF

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
colorscheme base16-dracula
inoremap <silent><expr> <c-space> coc#refresh()


" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')
colorscheme base16-onedark
lua << EOF
require('Comment').setup()
EOF
lua << EOF
require('telescope').setup{
  defaults = {
    mappings = {
      i = { -- or `n`
        ["<C-g>"] = require('telescope.actions').select_vertical,
      },
    },
  }
}
local function my_on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)

    -- your removals and mappings go here
    vim.keymap.set('n', '<C-g>',   api.node.open.vertical,              opts('Open: Vertical Split'))
end
require("cutlass").setup {cut_key = "x"}
require'nvim-tree'.setup { -- BEGIN_DEFAULT_OPTS
  auto_reload_on_write = true,
  disable_netrw = true,
  hijack_cursor = false,
  hijack_netrw = true,
  hijack_unnamed_buffer_when_opening = true,
  open_on_tab = false,
  sort_by = "name",
  update_cwd = false,
  on_attach = my_on_attach,
  view = {
    width = 30,
    side = "left",
    preserve_window_proportions = false,
    number = false,
    relativenumber = false,
    signcolumn = "yes",
  },
  renderer = {
    indent_markers = {
      enable = false,
      icons = {
        corner = "└ ",
        edge = "│ ",
        none = "  ",
      },
    },
    icons = {
      webdev_colors = false,
    },
  },
  hijack_directories = {
    enable = true,
    auto_open = true,
  },
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
  system_open = {
    cmd = nil,
    args = {},
  },
  diagnostics = {
    enable = false,
    show_on_dirs = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  filters = {
    dotfiles = false,
    custom = {},
    exclude = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 400,
  },
  actions = {
    use_system_clipboard = true,
    change_dir = {
      enable = true,
      global = false,
      restrict_above_cwd = false,
    },
    open_file = {
      quit_on_open = true,
      resize_window = false,
      window_picker = {
        enable = true,
        chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
  },
  trash = {
    cmd = "trash",
    require_confirm = true,
  },
  log = {
    types = {
      all = false,
      config = false,
      copy_paste = false,
      diagnostics = false,
      git = false,
      profile = false,
    },
  },
} -- END_DEFAULT_OPT
EOF
lua << EOF
require('gitsigns').setup {
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
}
EOF
let g:solarized_termcolors=256

let base16colorspace=256
let mapleader=";"

hi CocCursorRange guibg=#b16286 guifg=#ebdbb2

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

nmap <expr> <silent> <C-d> <SID>select_current_word()
function! s:select_current_word()
  if !get(b:, 'coc_cursors_activated', 0)
    return "\<Plug>(coc-cursors-word)"
  endif
  return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
endfunc


syntax enable
let g:airline#extensions#tabline#enabled = 1

nmap <silent> <C-Right> :vertical resize +1<CR>
nmap <silent> <C-Left> :vertical resize -1<CR>
"Netrw configuration
let g:netrw_keepdir = 0
let g:netrw_banner = 0
let g:netrw_altv = 1

" nnoremap <C-p> <cmd>:FzfLua files<cr>
" nnoremap <C-b> <cmd>:FzfLua buffers<cr>
" nnoremap <leader>s <cmd>:FzfLua live_grep<cr>
" TELESCOPE
nnoremap <C-p> <cmd>Telescope find_files<cr>
nnoremap <leader>s <cmd>Telescope live_grep<cr>
nnoremap <C-b> <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
nnoremap <leader>gc <cmd>Telescope git_commits<cr>
"Tabs
nmap <leader>tn :tabnew<cr>
nmap <leader>tc :tabclose<cr>
nmap <leader>tm :tabmove<cr>
"nnoremap fb <cmd> :Buffers<cr>
"nnoremap f <cmd> :Files<cr>
let g:airline#extensions#tabline#enabled = 0

"hi NonText ctermbg=none
"hi Normal guibg=NONE ctermbg=NONE
"Buffers
nmap bn :bn<cr>
nmap bp :bp<cr>
nmap bc :%bd<cr>
nmap bd :bd<cr>
nmap gn :tabp<cr>
"VIm fugitive
nmap <leader>gs :tab G<cr>
nmap <leader>gm :Gvdiffsplit!<cr>
nmap <leader>gl :tab G log
nmap <leader>df :diffget
"NETRw Window management
nmap <leader>dh :Sexplore<cr>
nmap <leader>dv :Vexplore<cr>
set incsearch       " search as characters are entered
set hlsearch        " highlight matche
set ignorecase      " ignore case when searching
set smartcase

" vimrc

"If 0, do not show the icons for one of 'git' 'folder' and 'files'
"1 by default, notice that if 'files' is 1, it will only display
"if nvim-web-devicons is installed and on your runtimepath.
"if folder is 1, you can also tell folder_arrows 1 to show small arrows next to the folder icons.
"but this will not work when you set renderer.indent_markers.enable (because of UI conflict)

" default will show icon by default if no icon is provided
" default shows no icon by default
nmap <leader>e :NvimTreeToggle<CR>

nmap <leader>o :NvimTreeOpen<CR>
nmap <leader>r :NvimTreeRefresh<CR>
nmap <leader>n :NvimTreeFindFile<CR>
" More available functions:
" NvimTreeOpen
" NvimTreeClose
" NvimTreeFocus
" NvimTreeFindFileToggle
" NvimTreeResize
" NvimTreeCollapse
" NvimTreeCollapseKeepBuffers

set termguicolors " this variable must be enabled for colors to be applied properly

" a list of groups can be found at `:help nvim_tree_highlight`

lua << EOF
local dap = require('dap')
dap.adapters.php = {
  type = 'executable',
  command = 'node',
  args = { os.getenv('HOME') .. '/code/vscode-php-debug/out/phpDebug.js' }
}
dap.configurations.php = {
  {
    type = 'php',
    request = 'launch',
    name = 'Listen for Xdebug',
    port = 9000,

  }
}
vim.fn.sign_define('DapBreakpoint', {text='>', texthl='', linehl='', numhl=''})
vim.fn.sign_define('DapStopped', {text='*', texthl='', linehl='', numhl=''})
EOF
nnoremap <leader>dh :lua require'dap'.toggle_breakpoint()<CR>
nnoremap <S-l> :lua require'dap'.step_into()<CR>
nnoremap <S-i> :lua require'dap'.step_out()<CR>
nnoremap <S-j> :lua require'dap'.step_over()<CR>
nnoremap <leader>dn :lua require'dap'.continue()<CR>
nnoremap <leader>dk :lua require'dap'.up()<CR>
nnoremap <leader>dj :lua require'dap'.down()<CR>
nnoremap <leader>d_ :lua require'dap'.terminate();require'dapui'.close();require'dap'.close();<CR>
nnoremap <leader>dr :lua require'dap'.repl.open({}, 'vsplit')<CR><C-w>l
nnoremap <leader>di :lua require'dap'.ui.variables.hover()<CR>
nnoremap <leader>di :lua require'dap'.ui.variables.visual_hover()<CR>
nnoremap <leader>d? :lua require'dap'.ui.variables.scopes()<CR>
nnoremap <leader>u_ :lua require'dapui'.open()<CR>
nnoremap <leader>u+ :lua require'dapui'.toggle()<CR>
lua << EOF
require("dapui").setup()
EOF
