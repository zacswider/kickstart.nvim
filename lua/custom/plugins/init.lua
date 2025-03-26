-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'nvimtools/none-ls.nvim',
    dependencies = {
      'nvimtools/none-ls-extras.nvim',
      'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
    },
    config = function()
      -- list of formatters & linters for mason to install
      require('mason-null-ls').setup {
        ensure_installed = {
          'ruff',
          'prettier',
          'shfmt',
        },
        automatic_installation = true,
      }

      local null_ls = require('null-ls')
      local sources = {
        require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
        require('none-ls.formatting.ruff_format'),
        null_ls.builtins.formatting.prettier.with { filetypes = { 'json', 'yaml', 'markdown' } },
        null_ls.builtins.formatting.shfmt.with { args = { '-i', '4' } },
      }

      local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
      null_ls.setup {
        -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
        sources = sources,
        update_in_insert = false,  -- This disables diagnostics updates while in insert mode
        -- you can reuse a shared lspconfig on_attach callback here
--        on_attach = function(client, bufnr)
          -- if client.supports_method('textDocument/formatting') then
    --         vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
    --         vim.api.nvim_create_autocmd('BufWritePre', {
    --           group = augroup,
    --           buffer = bufnr,
    --           callback = function()
    --             vim.lsp.buf.format { async = false }
    --           end,
    --         })
    --       end
    --     end,
      }
    end
  },
  {
    "wookayin/semshi",
    build = ":UpdateRemotePlugins",
    version = "*",
    init = function()
      -- Existing Semshi configuration
      vim.g['semshi#error_sign'] = false
      vim.g['semshi#filetypes'] = {'python'}
      
      -- IMPORTANT: Remove 'local' from the excluded highlight groups
      vim.g['semshi#excluded_hl_groups'] = {}  -- Empty list means highlight everything
      
      vim.g['semshi#mark_selected_nodes'] = 1
      vim.g['semshi#no_default_builtin_highlight'] = true
      vim.g['semshi#simplify_markup'] = true
      vim.g['semshi#error_sign'] = true
      vim.g['semshi#error_sign_delay'] = 1.5
      vim.g['semshi#always_update_all_highlights'] = true
      vim.g['semshi#tolerate_syntax_errors'] = true
      vim.g['semshi#update_delay_factor'] = 0.0001
      vim.g['semshi#self_to_attribute'] = true
    end,
    config = function()
      -- Set up a function to apply custom highlights
      local function CustomSemshiHighlights()
        vim.api.nvim_set_hl(0, "semshiLocal", { fg = "#32a899" })
      end
      
      -- Apply highlights after Semshi has loaded
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          -- Wait a bit for Semshi to initialize its highlighting
          vim.defer_fn(CustomSemshiHighlights, 100)
        end
      })
      
      -- Ensure highlights persist across colorscheme changes
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = CustomSemshiHighlights
      })
      
      -- Apply immediately if we're already in a Python file
      if vim.bo.filetype == "python" then
        vim.defer_fn(CustomSemshiHighlights, 100)
      end
    end,
  },
  {
    "rebelot/kanagawa.nvim",
  },
  {
    "EdenEast/nightfox.nvim"
  },
  {
    "neanias/everforest-nvim"
  },
  {
      'akinsho/toggleterm.nvim', 
      version = "*", 
      config = function()
        require("toggleterm").setup({
          -- This is the key you press in normal mode to open/close the terminal
          open_mapping = "<C-j>",  -- Control-j to toggle terminal
          insert_mappings = true,  -- Allow the mapping to work in insert mode too
          
          -- Other settings...
          direction = 'float',
          float_opts = {
            border = 'curved',
            winblend = 3,
          },
          on_open = function(term)
            vim.cmd("startinsert!")
          end,
        })
        
        -- These mappings are ONLY for when you're inside the terminal
        -- They help you exit terminal mode and navigate between windows
        function _G.set_terminal_keymaps()
          local opts = {buffer = 0}
          vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)  -- Exit terminal mode (fixed typo in <C-j><C-n>)
          vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)  -- Move to left window
          vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)  -- Move to window below
          vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)  -- Move to window above
          vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)  -- Move to right window
        end
        
        vim.cmd('autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()')
      end
  },
  -- Adding Harpoon 2 with sensible defaults
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      
      -- REQUIRED - setup harpoon
      harpoon:setup({
        settings = {
          save_on_toggle = true,
          sync_on_ui_close = true,
        }
      })
      
      -- Keymaps
      -- Mark a file
      vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, 
        { desc = "Harpoon add file" })
      
      -- Toggle quick menu
      vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, 
        { desc = "Harpoon menu" })
      
      -- Navigate to files
      vim.keymap.set("n", "<leader>h1", function() harpoon:list():select(1) end, 
        { desc = "Harpoon file 1" })
      vim.keymap.set("n", "<leader>h2", function() harpoon:list():select(2) end, 
        { desc = "Harpoon file 2" })
      vim.keymap.set("n", "<leader>h3", function() harpoon:list():select(3) end, 
        { desc = "Harpoon file 3" })
      vim.keymap.set("n", "<leader>h4", function() harpoon:list():select(4) end, 
        { desc = "Harpoon file 4" })
      
      -- Navigate through list sequentially
      vim.keymap.set("n", "<leader>hb", function() harpoon:list():prev() end, 
        { desc = "Harpoon prev file" })
      vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end, 
        { desc = "Harpoon next file" })
        

      -- Clear all items from the Harpoon list
      vim.keymap.set("n", "<leader>hc", function() 
        harpoon:list():clear()
        print("Harpoon list cleared")
      end, { desc = "Clear all harpoon marks" })

      -- Add UI extensions for split/vsplit capability
      harpoon:extend({
        UI_CREATE = function(cx)
          vim.keymap.set("n", "<C-v>", function()
            harpoon.ui:select_menu_item({ vsplit = true })
          end, { buffer = cx.bufnr })
      
          vim.keymap.set("n", "<C-x>", function()
            harpoon.ui:select_menu_item({ split = true })
          end, { buffer = cx.bufnr })
      
          vim.keymap.set("n", "<C-t>", function()
            harpoon.ui:select_menu_item({ tabedit = true })
          end, { buffer = cx.bufnr })
        end,
      })
      
      -- Enable highlight of current file in the harpoon list
      local extensions = require("harpoon.extensions")
      harpoon:extend(extensions.builtins.highlight_current_file())
    end
  },
  {
      'numToStr/Comment.nvim',
      opts = {
          -- add any options here
      }
  },
  {
    "kiyoon/jupynium.nvim",
    -- build = "pip3 install --user .",
    -- build = "uv pip install . --python=$HOME/.virtualenvs/jupynium/bin/python",
    build = "conda run --no-capture-output -n jupynium pip install .",
  },
}
