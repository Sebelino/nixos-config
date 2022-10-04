set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath=&runtimepath

colorscheme wombat-sebelino

" Settings that should pretty much always be enabled
set nocompatible
syntax on
filetype plugin indent on

" Line numbers
set number

" Keep cursor centered
set scrolloff=999

" Toggle search highlighting
map  <F12> :set hls!<CR>
imap <F12> <ESC>:set hls!<CR>a
vmap <F12> <ESC>:set hls!<CR>gv

" Shortcut for :qa and :w
nnoremap <silent><C-y> :qa<CR>
nnoremap <silent><C-s> :w<CR>

" Upon reopening a file, jump to the position held at the end of the previous session
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Toggle text wrapping with F11
map <F11> :set wrap!<CR>

" Upon pressing Tab, put spaces instead of the tab character
set expandtab

" Use 4 spaces for tabs
set tabstop=4 shiftwidth=4 softtabstop=4

" vim-gitgutter
set updatetime=100  " How often to update markers to the left
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)

set backup
set backupdir=~/.vim/backup/

set writebackup
set backupcopy=yes
au BufWritePre * let &bex = '@' . strftime("%F.%H:%M")

" Save-alias
command W w
command Q q

" YAML editing
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

" vim-terraform
nnoremap <A-l> :TerraformFmt<CR>

" vim-markdown
let g:vim_markdown_folding_disabled = 1

" nvim-cmp

" vim-plug is installed at ~/.local/share/nvim/site/autoload/plug.vim
" After updating this list, run :PlugInstall
call plug#begin()
Plug 'hashivim/vim-terraform'
Plug 'LnL7/vim-nix'
Plug 'airblade/vim-gitgutter'
Plug 'preservim/vim-markdown'

" nvim-cmp
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
" For vsnip users
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'

call plug#end()

" nvim-cmp
set completeopt=menu,menuone,noselect
lua <<EOF
  -- Set up nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Set up lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
  }
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['terraformls'].setup {
    capabilities = capabilities,
    flags = lsp_flags,
  }
EOF

lua <<EOF
  cmp = require('cmp')
  function setAutoCmp(mode)
    if mode then
      cmp.setup({
        completion = {
          autocomplete = { require('cmp.types').cmp.TriggerEvent.TextChanged }
        }
      })
    else
      cmp.setup({
        completion = {
          autocomplete = false
        }
      })
    end
  end

  -- enable automatic completion popup on typing
  vim.cmd('command AutoCmpOn lua setAutoCmp(true)')

  -- disable automatic competion popup on typing
  vim.cmd('command AutoCmpOff lua setAutoCmp(false)')
EOF
