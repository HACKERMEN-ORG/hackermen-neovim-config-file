vim.lsp.enable({
	-- Core Development
	"lua_ls", -- Lua for Neovim config
	"clangd", -- C/C++ development
	"pylsp", -- Python development
	"bashls", -- Shell scripts
	"jsonls", -- JSON files

	-- Build Systems & Tools
	"neocmake", -- CMake
	"buf_ls", -- Protocol Buffers

	-- Web Development
	"eslint", -- JavaScript/TypeScript linting
	"denols", -- Deno TypeScript/JavaScript
	"tsserver", -- TypeScript/JavaScript (alternative)

	"gopls", -- Go development

	-- DevOps & Configuration
	"yamlls", -- YAML files
	"dockerls", -- Docker files

	-- Misc Languages
	"vimls", -- Vimscript
	"svls", -- SystemVerilog
	"vhdl_ls",
	"cl_lsp", -- Common Lisp
})
