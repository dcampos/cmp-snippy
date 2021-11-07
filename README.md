# cmp-snippy

[nvim-snippy][1] completion source for [nvim-cmp][2].

[1]: https://github.com/dcampos/nvim-snippy
[2]: https://github.com/hrsh7th/nvim-cmp

## Setup

Install using your favorite plugin manager:

```viml
Plug 'dcampos/nvim-snippy'
```

Enable:

```lua
require 'cmp'.setup {
  snippet = {
    expand = function(args)
      require 'snippy'.expand_snippet(args.body)
    end
  },

  sources = {
    { name = 'snippy' }
  }
}
```

## Avanced mappings

If you want to use <kbd>Tab</kbd>/<kbd>S-Tab</kbd> for expanding and also for
navigating the completion menu, you can try the following code (adapted from
the nvim-cmp wiki):

```lua
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local snippy = require('snippy')
local cmp = require('cmp')

cmp.setup {

  -- ...

    mapping = {

        -- ... Your other mappings ...

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            elseif snippy.can_expand_or_advance() then
                snippy.expand_or_advance()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            elseif snippy.can_jump(-1) then
                snippy.previous()
            else
                fallback()
            end
        end, { "i", "s" }),

        -- ... Your other mappings ...

  }

  -- ...

}

```

Note, however, that using <kbd>Tab</kbd> for both navigating and
expanding snippets can cause unexpected and annoying issues. So it may be
better to just use different mappings to select completion items (like
<kbd>C-J</kbd>/<kbd>C-K</kbd>) and keep <kbd>Tab</kbd> for expanding
snippets/jumping, or vice-versa.
