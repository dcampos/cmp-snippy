# cmp-snippy

[nvim-snippy][1] completion source for [nvim-cmp][2].

[1]: https://github.com/dcampos/nvim-snippy
[2]: https://github.com/hrsh7th/nvim-cmp

## Setup

Install using your favorite plugin manager:

```viml
Plug 'dcampos/cmp-snippy'
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
