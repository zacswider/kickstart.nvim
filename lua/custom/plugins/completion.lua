return {
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' }, -- optional
    version = '1.*',
    opts = {
      keymap = { preset = 'enter' },
      appearance = {
        nerd_font_variant = 'mono'
      },
      -- (Default) Only show the documentation popup when manually triggered
      completion = { documentation = { auto_show = false } },
      fuzzy = { implementation = "prefer_rust_with_warning" }
    },
    opts_extend = { "sources.default" }
  }
}
