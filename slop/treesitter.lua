return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPost", "BufNewFile" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	opts = {
		-- Full parser list optimized for M4 Pro Max development
		ensure_installed = {
			-- Core languages
			"c",
			"cpp",
			"lua",
			"php",
			"python",
			"json",
			"bash",
			-- Web development
			"javascript",
			"typescript",
			"tsx",
			"html",
			-- Systems programming
			"rust",
			"go",
			-- Configuration & markup
			"yaml",
			"toml",
			"markdown",
			"markdown_inline",
			-- DevOps & tools
			"dockerfile",
			"diff",
			-- Advanced parsing
			"regex",
			"devicetree",
		},

		TSUpdate = true,
		-- Install parsers synchronously (only applied to `ensure_installed`)
		sync_install = true,

		-- Enable auto-install for M4 Pro Max
		auto_install = true,

		highlight = {
			enable = true,
			-- Enable additional regex highlighting for rich experience
			additional_vim_regex_highlighting = true,
		},
		indent = { enable = true },
		textobjects = {
			select = {
				enable = true,
				lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["aa"] = "@parameter.outer",
					["ia"] = "@parameter.inner",
					["af"] = "@function.outer",
					["if"] = "@function.inner",
					["ac"] = "@class.outer",
					["ic"] = "@class.inner",
				},
			},
			move = {
				enable = true,
				set_jumps = true, -- whether to set jumps in the jumplist
				goto_next_start = {
					["]m"] = "@function.outer",
					["]]"] = "@class.outer",
				},
				goto_previous_start = {
					["[m"] = "@function.outer",
					["[["] = "@class.outer",
				},
			},
		},
	},
}
