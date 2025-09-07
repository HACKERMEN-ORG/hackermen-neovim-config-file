return {
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "hpp", "h" },
	cmd = {
		"clangd",
		"--background-index",
		"--background-index-priority=background",
		"-j=4",
		"--clang-tidy",
		"--pch-storage=memory",
		"--log=error", -- Changed from verbose to reduce noise
		"--completion-style=detailed",
		"--header-insertion=iwyu",
		"--header-insertion-decorators",
		"--suggest-missing-includes",
		"--cross-file-rename",
		"--function-arg-placeholders",
		"--fallback-style=llvm",
	},
	init_options = {
		usePlaceholders = true,
		completeUnimported = true,
		clangdFileStatus = true,
	},
	capabilities = {
		offsetEncoding = { "utf-16" },
	},
}
