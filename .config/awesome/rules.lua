awful.rules.rules = {
  {
    rule = {},
    properties = {
      size_hints_honor = false,
      focus = true,
      keys = keys.client,
      buttons = buttons.client,
      tag = function() return tags.selected end,
      titlebars_enabled = true
    }
  }
}
