local awful = require("awful")
local naughty = require("naughty")

function script_path()
   local str = debug.getinfo(2, "S").source:sub(2)
   return str:match("(.*/)")
end

local workspace_grid = {}

function workspace_grid:new(args)
   return setmetatable({}, {__index = self}):init(args)
end

function workspace_grid:init(args)
   self.rows = args.rows or 2
   self.columns = args.columns or 3
   self.position = args.position or "top_middle"
   self.visual = args.visual or true
   self.cycle = args.cycle or false

   if self.visual then
      awful.screen.connect_for_each_screen(function(s)
            s.workspace_notification_id = nil
      end)
      tag.connect_signal("property::selected", function(t)
        self:on_tag_selected(t)
      end)
   end

   return self
end

function workspace_grid:navigate(direction)
   local t = awful.screen.focused().selected_tag
   local i = t.index - 1
   local c = self.columns
   local r = self.rows

   if not self.cycle then
     -- Top row
     if (i < c)            and (direction == "up")    then return true end
     -- Left column
     if (i % c == 0)       and (direction == "left")  then return true end
     -- Right column
     if ((i + 1) % c == 0) and (direction == "right") then return true end
     -- Bottom row
     if (i >= (r - 1) * c) and (direction == "down")  then return true end
   end

   action = {
      ["down"] = (i + c) % (r * c) + 1,
      ["up"] = (i - c) % (r * c) + 1,
      ["left"] = (math.ceil((i + 1) / c) - 1) * c + ((i - 1) % c) + 1,
      ["right"] = (math.ceil((i + 1) / c) - 1) * c + ((i + 1) % c) + 1,
   }
   local j = action[direction]

   -- Switch tags on all screens at the same time.
   -- TODO: Add option to switch per-screen.
   for s in screen do
      t = s.tags[j]
      if t then t:view_only() end
   end
end

function workspace_grid:on_tag_selected(t)
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
      icon_path = "icons/workspace_" .. self.rows .. "x" .. self.columns .. "_" .. t.index .. ".svg"
      notification = naughty.notify({
            icon = script_path() .. icon_path,
            icon_size = 100,
            margin = 0,
            position = self.position,
            preset = naughty.config.presets.normal,
            replaces_id = s.workspace_notification_id,
            screen = i,
            text = nil,
            timeout = 1,
      })
      s.workspace_notification_id = notification.id
   end
end

return setmetatable(workspace_grid, { __call = workspace_grid.new,})
