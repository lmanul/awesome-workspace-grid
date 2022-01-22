![Animated screenshot](https://raw.githubusercontent.com/lmanul/awesome-workspace-grid/master/screenshot.gif)

## Installation

Clone this repository into your `awesome` configuration directory:

```
cd ~/.config/awesome
git clone https://github.com/lmanul/awesome-workspace-grid.git
```

## Usage

Basic usage, in `rc.lua`:

```
local workspace_grid = require("awesome-workspace-grid")
grid = workspace_grid({
  rows = 3,
  columns = 3,
})
```

Please make sure that `rows` × `columns` is equal to your number of tags, as
defined by the call to `awful.tag()` in your configuration.

Define keyboard shortcuts like so:

```
-- Insert after 'globalkeys' is defined but before it is passed to 'root':

tag_nav_mod_keys = { "Control" }
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

## Options

Arguments that can be passed to the contructor (all of them are optional):

| Arg                  | Default        | Description                              |
|----------------------|----------------|------------------------------------------|
| `rows`               | 2              | Number of rows (1 to 9)                  |
| `columns`            | 3              | Number of columns (1 to 9)               |
| `cycle`              | `false`        | Whether to cycle at grid edges           |
| `icon_size`          | 100            | Size of icon in notification             |
| `position`           | `"top_middle"` | Notification position on the screen      |
| `visual`             | `true`         | Whether to show workspace changes        |
| `switch_all_screens` | `true`         | Whether tag changes apply to all screens |
