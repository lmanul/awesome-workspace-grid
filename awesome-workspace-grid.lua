local awful = require("awful")

local workspace_grid = {}

function workspace_grid:new(args)
  return setmetatable({}, {__index = self}):init(args)
end

function workspace_grid:init(args)
  self.test = 0
  return self
end

local rows = 2
local columns = 3

function workspace_grid:navigate(direction)
  log(tostring(direction))
  local t = awful.screen.focused().selected_tag
  local i = t.index - 1
  local c = columns
  local r = rows
  log("Rows " .. tostring(rows))
  log("Cols" .. tostring(columns))

  -- Don't cycle.
  -- Top row
  if (i < c)            and (direction == "up")    then return true end
  -- Left column
  if (i % c == 0)       and (direction == "left")  then return true end
  -- Right column
  if ((i + 1) % c == 0) and (direction == "right") then return true end
  -- Bottom row
  if (i >= (r - 1) * c) and (direction == "down")  then return true end

  action = {
    ["down"] = (i + columns) % (rows * columns) + 1,
    ["up"] = (i - columns) % (rows * columns) + 1,
    ["left"] = (math.ceil((i + 1) / columns) - 1) * columns + ((i - 1) % columns) + 1,
    ["right"] = (math.ceil((i + 1) / columns) - 1) * columns + ((i + 1) % columns) + 1,
  }
  local j = action[direction]
  log(tostring(j))

  -- Switch tags on all screens at the same time.
  for s in screen do
    log(tostring(s))
    t = s.tags[j]
    if t then t:view_only() end
  end
end

return setmetatable(workspace_grid, {
  __call = workspace_grid.new,
})
