-- Common Lisp: Conjure (swank) helpers, local HyperSpec, nvim-paredit.
-- Keys are buffer-local to lisp buffers, under <localleader> (",").

local ok_pe, paredit = pcall(require, "nvim-paredit")
if ok_pe then
  -- Defaults: >) <) slurp/barf fwd, <( >( slurp/barf back,
  -- >e <e drag element, >f <f drag form, ,o ,O raise form/element.
  paredit.setup({})
end

-- localdocs copy first; the downloaded copy is the fallback if localdocs is reorganised.
local clhs_root = vim.fn.expand("~/localdocs/hyperspec/")
if vim.fn.filereadable(clhs_root .. "Data/Map_Sym.txt") == 0 then
  clhs_root = vim.fn.expand("~/.local/share/hyperspec/HyperSpec/")
end
local swank_port = 4005
local clhs_map

local function clhs_lookup(sym)
  if not clhs_map then
    clhs_map = {}
    local lines = vim.fn.readfile(clhs_root .. "Data/Map_Sym.txt")
    for i = 1, #lines - 1, 2 do
      clhs_map[lines[i]] = lines[i + 1]:gsub("^%.%./", "")
    end
  end
  sym = sym:upper():gsub("^.*:", "")
  local rel = clhs_map[sym]
  if not rel then
    vim.notify("CLHS: no entry for " .. sym, vim.log.levels.WARN)
    return
  end
  local path = clhs_root .. rel
  if vim.fn.executable("xdg-open") == 1 and (os.getenv("DISPLAY") or os.getenv("WAYLAND_DISPLAY")) then
    vim.fn.jobstart({ "xdg-open", path }, { detach = true })
  end
  return path
end

local function eval(code)
  require("conjure.eval")["eval-str"]({ code = code, origin = "custom" })
end

local function form_text(root)
  local f = require("conjure.extract").form({ ["root?"] = root })
  return f and f.content
end

-- CL TRACE prints to swank's *trace-output*, which Conjure never shows. Wrap the
-- function with SBCL encapsulation instead: output goes to *standard-output*,
-- which Conjure captures per eval. BT adds a backtrace ("log breakpoint").
local trace_tmpl = [[(sb-int:encapsulate '%%s 'conjure-trace
  (lambda (fn &rest args) (format t "~&;; > ~S ~S~%%%%" '%%s args) %s
    (let ((r (multiple-value-list (apply fn args)))) (format t "~&;; < ~S~%%%%" r) (values-list r))))]]
local untrace_tmpl = "(sb-int:unencapsulate '%s 'conjure-trace)"

local function wrap_form(fn)
  return function()
    local c = form_text(false)
    if c then eval(("(%s '%s)"):format(fn, c)) end
  end
end

local function wrap_word(tmpl)
  return function()
    eval(tmpl:format(vim.fn.expand("<cword>")))
  end
end

vim.api.nvim_create_user_command("CLHS", function(o)
  local p = clhs_lookup(o.args ~= "" and o.args or vim.fn.expand("<cword>"))
  if p then print(p) end
end, { nargs = "?" })

vim.api.nvim_create_user_command("SwankStart", function()
  vim.fn.jobstart({ vim.fn.expand("~/.local/bin/sbcl"), "--eval", "(ql:quickload :swank)",
    "--eval", ("(swank:create-server :port %d :dont-close t)"):format(swank_port), "--eval", "(loop (sleep 3600))" }, { detach = true })
end, {})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lisp",
  group = vim.api.nvim_create_augroup("commonlisp_conjure", { clear = true }),
  callback = function(ev)
    local m = function(lhs, rhs, desc)
      vim.keymap.set("n", "<localleader>" .. lhs, rhs, { buffer = ev.buf, desc = desc })
    end
    m("hs", function() vim.cmd("CLHS") end, "HyperSpec (local) for word")
    m("hd", wrap_word("(documentation '%s 'function)"), "Docstring of word")
    m("m1", wrap_form("macroexpand-1"), "macroexpand-1 current form")
    m("ma", wrap_form("macroexpand"), "macroexpand current form")
    m("mA", wrap_form("swank/backend:macroexpand-all"), "macroexpand-all (code walker)")
    m("tt", function() local w = vim.fn.expand("<cword>"); eval(trace_tmpl:format(""):format(w, w)) end, "Trace word")
    m("tu", wrap_word(untrace_tmpl), "Untrace word")
    -- No SLDB in Conjure: a real (break) hangs the connection. Log args+backtrace instead.
    m("bb", function() local w = vim.fn.expand("<cword>"); eval(trace_tmpl:format("(sb-debug:print-backtrace :count 12 :stream *standard-output*)"):format(w, w)) end, "Breakpoint: log args+backtrace")
    m("bu", wrap_word(untrace_tmpl), "Remove breakpoint on word")
    m("ss", function() vim.cmd("SwankStart") end, "Start SBCL swank on :4005")
  end,
})

