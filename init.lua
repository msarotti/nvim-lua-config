-- init.lua
local lazypath = vim.fn.stdpath("config") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
-- Set leader key
vim.g.mapleader = " "        -- or whatever key you prefer, like ",", "\\", etc.
vim.g.maplocalleader = ","   -- optional, for <localleader>

vim.opt.ignorecase = true     -- Make searches case-insensitive
vim.opt.smartcase = true

require("lazy").setup({
	{
		"junegunn/fzf",
		build = "./install --all"
	},
	{
		"junegunn/fzf.vim",
		dependencies = { "junegunn/fzf" }
	},
	{ 
		"github/copilot.vim", name = "copilot", priority = 1000 
	},
	{ 
		"catppuccin/nvim", name = "catppuccin", priority = 1000 
	},
	{
		"mason-org/mason.nvim",
		opts = {}
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
      		require("lspconfig").intelephense.setup({})
		vim.api.nvim_create_autocmd("LspAttach", {
		  callback = function(args)
		    local buf = args.buf
		    local opts = { buffer = buf, noremap = true, silent = true }

		    -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		    -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		    -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
		    vim.keymap.set("n", "<leader>ai", vim.lsp.buf.code_action, opts)
		  end,
		})
    		end,
	},
	{
	    "nvim-lualine/lualine.nvim",
	    dependencies = { "nvim-tree/nvim-web-devicons" },
	    config = function()
	      require("lualine").setup({
		options = {
		  theme = "gruvbox",  -- or "tokyonight", "auto", etc.
		  section_separators = "",
		  component_separators = "",
		},
		sections = {
		  lualine_b = { "branch" },
		  lualine_c = { "filename" },
		  lualine_x = { "encoding", "fileformat", "filetype" },
		  --lualine_y = { require("gitsigns").blame_line },
		  lualine_z = { "location" }
		},
	      })
	    end,
	  },

	  -- Git signs (for blame and gutter signs)
	  {
	    "lewis6991/gitsigns.nvim",
	    config = function()
	      require("gitsigns").setup({
		current_line_blame = false,
		current_line_blame_opts = {
		  delay = 300,
		  virt_text_pos = "eol", -- or 'overlay', 'right_align'
		},
	      })
	    end,
    	},
	{
	    "mfussenegger/nvim-dap",
	    config = function()
	      -- Optional basic keymaps
	      local dap = require("dap")
	      vim.keymap.set("n", "<F5>", dap.continue)
	      vim.keymap.set("n", "<F10>", dap.step_over)
	      vim.keymap.set("n", "<F11>", dap.step_into)
	      vim.keymap.set("n", "<F12>", dap.step_out)
	      vim.keymap.set("n", "<Leader>b", dap.toggle_breakpoint)
	      vim.keymap.set("n", "<Leader>B", function()
		dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
	      end)
	    end,
	},
	{
	  "rcarriga/nvim-dap-ui",
	  dependencies = { 
		  "mfussenegger/nvim-dap",
		  "nvim-neotest/nvim-nio",
	  },
	  config = function()
	    local dap, dapui = require("dap"), require("dapui")
	    dapui.setup()
	    dap.listeners.after.event_initialized["dapui_config"] = function()
	      dapui.open()
	    end
	    dap.listeners.before.event_terminated["dapui_config"] = function()
	      dapui.close()
	    end
	    dap.listeners.before.event_exited["dapui_config"] = function()
	      dapui.close()
	    end
	  end,
	},
	{
	  "theHamsta/nvim-dap-virtual-text",
	  dependencies = { "mfussenegger/nvim-dap" },
	  config = function()
	    require("nvim-dap-virtual-text").setup()
	  end,
	},
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")

		cmp.setup({
			snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body)
			end,
			},
			mapping = cmp.mapping.preset.insert({
			["<C-Space>"] = cmp.mapping.complete(),  -- Trigger autocomplete
			["<CR>"] = cmp.mapping.confirm({ select = true }),
			["<Tab>"] = cmp.mapping.select_next_item(),
			["<S-Tab>"] = cmp.mapping.select_prev_item(),
			}),
			sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			}),
		})
		end,
  	},
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { 'nvim-lua/plenary.nvim' },
	    	config = function()
	      		require('telescope').setup{}
	    	end,
	},
	{
		{ import = "plugins" }
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "habamax" } },
	-- automatically check for plugin updates
	checker = { enabled = true },
})

vim.cmd.colorscheme "catppuccin-frappe"

vim.keymap.set("n", "<leader>ff", ":Files<CR>", { desc = "FZF: Find files" })
vim.keymap.set("n", "<leader>fb", ":Buffers<CR>", { desc = "FZF: Find buffers" })
vim.keymap.set("n", "<leader>fg", ":GFiles<CR>", { desc = "FZF: Git files" })
vim.keymap.set("n", "<leader>fl", ":Lines<CR>", { desc = "FZF: Search lines in open buffers" })
vim.keymap.set("n", "<leader>fr", ":Rg<CR>", { desc = "FZF: Ripgrep search" })
vim.keymap.set("n", "<leader>fh", ":History<CR>", { desc = "FZF: Command history" })
vim.keymap.set("n", "<leader>gb", function()
  require("gitsigns").toggle_current_line_blame()
end, { desc = "Toggle Git blame for current line" })

vim.keymap.set("n", "<leader>dq", function()
  local dap = require("dap")
  local dapui = require("dapui")
  dap.terminate()
  dapui.close()
end, { desc = "Terminate debugger and close UI" })

vim.keymap.set("n", "<leader>de", function()
  local diagnostics = vim.diagnostic.get()
  if diagnostics and diagnostics[1] then
    vim.api.nvim_echo({ { diagnostics[1].message, "ErrorMsg" } }, false, {})
  end
end, { desc = "Echo first diagnostic message" })


local dap = require("dap")

dap.adapters.php = {
  type = "executable",
  command = "node",
  args = { vim.fn.stdpath("data") .. "/mason/packages/php-debug-adapter/extension/out/phpDebug.js" },
}

dap.configurations.php = {
  {
    type = "php",
    request = "launch",
    name = "Listen for Xdebug-Nvim",
    port = 9003,
    pathMappings = {
      ["/var/www/html"] = "${workspaceFolder}", -- adjust to match your container/server path
    },
  },
}

vim.diagnostic.config({
  virtual_text = {
    prefix = "●",  -- Could be '●', '▎', '■', etc.
    spacing = 2,
    severity = { min = vim.diagnostic.severity.ERROR }, -- Show only errors or remove for all
  },
  signs = true,      -- Show signs in the sign column
  underline = true,  -- Underline problematic text
  update_in_insert = false, -- Update diagnostics while typing (optional)
  severity_sort = true,
})


vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })

local telescope = require('telescope.builtin')

-- Keybindings
vim.keymap.set('n', '<Leader>gs', function()
  telescope.lsp_document_symbols()
end, { desc = '[G]oto [S]ymbol in file' })

vim.keymap.set('n', '<Leader>gw', function()
  telescope.lsp_workspace_symbols()
end, { desc = '[G]oto [W]orkspace class' })


-- References
vim.keymap.set('n', '<Leader>gr', telescope.lsp_references, { desc = '[G]oto [R]eferences' })

-- Definitions
vim.keymap.set('n', '<Leader>gd', telescope.lsp_definitions, { desc = '[G]oto [D]efinition' })

-- Implementations
vim.keymap.set('n', '<Leader>gi', telescope.lsp_implementations, { desc = '[G]oto [I]mplementation' })

-- Type Definitions
vim.keymap.set('n', '<Leader>gt', telescope.lsp_type_definitions, { desc = '[G]oto [T]ype Definition' })
