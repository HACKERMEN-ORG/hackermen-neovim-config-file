return {
	settings = {
		pylsp = {
			plugins = {
				-- EXPLICITLY DISABLE THE META-LINTER
				flake8 = {
					enabled = false,
				},

				-- LINTERS YOU LIKE - ENABLED
				pyflakes = {
					enabled = true,
				},
				mccabe = {
					enabled = true,
					threshold = 15,
				},
				pydocstyle = {
					enabled = false,
				},

				-- LINTER YOU HATE - DISABLED (kept for clarity)
				pycodestyle = {
					enabled = false,
				},

				-- REFACTORING ENGINE - ENABLED
				rope = {
					enabled = true,
				},

				-- FORMATTER - CHOOSE ONE
				yapf = {
					enabled = true,
				},
				autopep8 = {
					enabled = false,
				},
			},
		},
	},
}
