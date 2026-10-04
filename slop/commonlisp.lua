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

-- Use the Conjure build with the CL features (stickers, debugger, trace, macroexpand,
-- HyperSpec) from ~/src/conjure-cl-all instead of plugged/conjure, when it exists.
local cl_all = vim.fn.expand("~/src/conjure-cl-all")
if vim.fn.isdirectory(cl_all) == 1 then
  vim.opt.rtp:remove(vim.fn.expand("~/.config/nvim/plugged/conjure"))
  vim.opt.rtp:prepend(cl_all)
  vim.g["conjure#client#common_lisp#swank#hyperspec_root"] = clhs_root
  vim.g["conjure#client#common_lisp#swank#mapping#sticker_toggle"] = "st" -- ,ss is SwankStart
end

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

-- Wrap the function with SBCL encapsulation: output goes to *standard-output*,
-- which Conjure captures per eval. %s adds a backtrace ("log breakpoint").
local trace_tmpl = [[(sb-int:encapsulate '%%s 'conjure-trace
  (lambda (fn &rest args) (format t "~&;; > ~S ~S~%%%%" '%%s args) %s
    (let ((r (multiple-value-list (apply fn args)))) (format t "~&;; < ~S~%%%%" r) (values-list r))))]]
local untrace_tmpl = "(sb-int:unencapsulate '%s 'conjure-trace)"

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
    -- The cl-all Conjure maps: hs HyperSpec, m1/ma macroexpand-1/-all, tt/ta trace/untrace all,
    -- st/sl/sc stickers, dr debugger restart. A real (break) now shows the debugger in the log.
    m("hd", wrap_word("(documentation '%s 'function)"), "Docstring of word")
    -- Breakpoint-as-log: print args and a backtrace on each call, without stopping.
    m("bb", function() local w = vim.fn.expand("<cword>"); eval(trace_tmpl:format("(sb-debug:print-backtrace :count 12 :stream *standard-output*)"):format(w, w)) end, "Breakpoint: log args+backtrace")
    m("bu", wrap_word(untrace_tmpl), "Remove breakpoint on word")
    m("ss", function() vim.cmd("SwankStart") end, "Start SBCL swank on :4005")
  end,
})

