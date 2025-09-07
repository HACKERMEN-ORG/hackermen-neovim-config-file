return {
	cmd = { "cl-lsp" },
	filetypes = { "lisp", "cl", "asd", "ros" },
	root_dir = function(fname)
		local util = require("lspconfig.util")
		return util.root_pattern("*.asd", ".git")(fname) or util.path.dirname(fname)
	end,
	single_file_support = true,
	settings = {
		commonLisp = {
			lispImplementation = "sbcl",
		},
	},
}
