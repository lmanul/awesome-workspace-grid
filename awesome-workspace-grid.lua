local awful = require("awful")
local naughty = require("naughty")

function on_tag_selected(t)
  if t.screen == nil then
    return
  end
  -- Only need to do anything on the focused screen.
  if t.screen.index ~= awful.screen.focused().index then
    return
  end
  if t.selected == false then
    -- This is the tag we are leaving
    return
  end
  for i = 1, screen.count() do
     s = screen[i]
     notification = naughty.notify({
           position = "top_middle",
           preset = naughty.config.presets.normal,
           replaces_id = s.workspace_notification_id,
           screen = i,
           text = t.name,
           timeout = 1,
     })
     s.workspace_notification_id = notification.id
  end
end

local workspace_grid = {}

function workspace_grid:new(args)
  return setmetatable({}, {__index = self}):init(args)
end

function workspace_grid:init(args)
   self.rows = args.rows
   self.columns = args.columns

   if args.visual then
      awful.screen.connect_for_each_screen(function(s)
            s.workspace_notification_id = nil
      end)
      tag.connect_signal("property::selected", on_tag_selected)
   end

   return self
end

function workspace_grid:navigate(direction)
  local t = awful.screen.focused().selected_tag
  local i = t.index - 1
  local c = self.columns
  local r = self.rows

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
    ["down"] = (i + c) % (r * c) + 1,
    ["up"] = (i - c) % (r * c) + 1,
    ["left"] = (math.ceil((i + 1) / c) - 1) * c + ((i - 1) % c) + 1,
    ["right"] = (math.ceil((i + 1) / c) - 1) * c + ((i + 1) % c) + 1,
  }
  local j = action[direction]

  -- Switch tags on all screens at the same time.
  for s in screen do
    t = s.tags[j]
    if t then t:view_only() end
  end
end

return setmetatable(workspace_grid, {
  __call = workspace_grid.new,
})
