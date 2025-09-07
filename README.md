# Minimal nvim config optional AI slop (enjoy!)

A friend sent me a neomutt configuration which was thousands of lines
of LLM code, using libraries where even the READMEs are written by
LLMs. Surprisingly, it worked pretty good. Human being were never any
good at writing VimScript anyway. Of course, to make even tiny edits,
due to the extreme unnecessary complexity brought in by the LLM, requires
the use of another LLM. Blargh!

The solution: actually use a decent, simple init written by a human,
and put the rest in the "optional" slop folder. Problem solved!

# Install

Run nvim and do,`:PlugInstall`. BAM! Future travellers: you should do `:PlugUpdate`.

# FEATURES

- [Structural editing](http://danmidwood.com/content/2014/11/21/animated-paredit.html)
- Global leader is Spacebar. Spacevim!
- Local leader is comma.
- Spellcheck and shellcheck keybindings.
- (sane) Completion. See equwal's [tag-gen](https://github.com/equwal/tag-gen) project.
- Which-key. Learn vim!
- Goyo (For writing words. Automatically turns on when editing neomutt buffers)
- <++> templating (see my <++> [tmpl](https://therealtruex.com/posts/tmpl-insanely-simple-templates) project)
- Ask what you meant using fzf when you try try to open a file that doesn't exist.
- Save your place in the buffer for later.
- mode line
- Slightly modified vim defaults (very slightly). See the only file for details.

# NON-FEATURES
- Not crazy modifications to vim defaults
- Only one file (everything else in "slop" folder)
- No major changes to the packages used
- No window management. Use a terminal multiplexer.
- No claude code. Same.

Source your own config at the bottom of the init.lua and work from these sane defaults. 

## FAQ: Frequent Answers to Questions

### "Source your own config at the bottom of the init.lua and work froM these sane defaults"

Then, make changes to the init.lua and send a pull request.

### You don't need claude in your vim

ARGH. Just use dvtm/mtm/abduco or your window manager to deal with
it. None of the claude vim projects are smart enough to send parts of
buffers to the claude like slime does for lisp. Those claude vim packages
are just glorified terminals using vim as a (very bad) multiplexer.

### Plugged *is* better than Lazy

Lazy is written by AI. The point of this is to not be written by
AI. Complex shit breaks!

### Here is your prompt, SIR:

```
start adding individual feature s one by one which only take
up 1-10 lines. Don't import all the config, just the most basic
config. For individual lines, write what it does and ask to add it
in. For packages, read the github pages and their default configuration
to minimize the edits needed. Opt for the most default configuration if
possible.
```

### Don't add hundreds of lines of AI slop to my config.
