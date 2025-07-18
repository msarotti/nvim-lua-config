-- plugins/treesitter.lua
return {
	{
	  "nvim-treesitter/nvim-treesitter",
	  build = ":TSUpdate",
	  event = { "BufReadPost", "BufNewFile" },
	  config = function()
	    require("nvim-treesitter.configs").setup {
	      ensure_installed = {
		"php", "lua", "javascript", "html", "css", "bash", -- Add any other languages you use
	      },
	      highlight = {
		enable = true,
		additional_vim_regex_highlighting = false,
	      },
	      indent = {
		enable = true
	      },
	    }
	  end
	},
	{
	  "nvim-treesitter/playground",
	  cmd = "TSPlaygroundToggle",
	  config = function()
	    vim.keymap.set("n", "<leader>tp", "<cmd>TSPlaygroundToggle<CR>", { desc = "Toggle Treesitter Playground" })
	  end
	}
}
