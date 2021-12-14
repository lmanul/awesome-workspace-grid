# awesome-workspace-grid

Sample usage:

```
local workspace_grid = require("awesome-workspace-grid")
grid = workspace_grid({
  rows = 2,        -- only 2 supported for now!
  columns = 3,     -- only 3 supported for now!
  visual = true,   -- whether to show workspace changes
})

globalkeys = gears.table.join(globalkeys,
  awful.key(tag_nav_mod_keys, "Up",
            function () grid:navigate("up") end, {description = "Up", group="Tag"}),
  awful.key(tag_nav_mod_keys, "Down",
            function () grid:navigate("down") end, {description = "Down", group="Tag"}),
  awful.key(tag_nav_mod_keys, "Left",
            function () grid:navigate("left") end, {description = "Left", group="Tag"}),
  awful.key(tag_nav_mod_keys, "Right",
            function () grid:navigate("right") end, {description = "Right", group="Tag"}),
)
```
