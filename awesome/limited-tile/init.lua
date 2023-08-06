-- Grab environment we need
local client = require('awful.client')
local ipairs = ipairs
local math = math
local capi = {
  mouse = mouse,
  screen = screen,
  mousegrabber = mousegrabber,
}

local tile = {}

-- @beautiful beautiful.layout_limitedtile

--- Jump mouse cursor to the client's corner when resizing it.
tile.resize_jump_to_corner = false

local function mouse_resize_handler(c, _, _, _, orientation)
  orientation = orientation or 'tile'
  local wa = c.screen.workarea
  local mwfact = c.screen.selected_tag.master_width_factor
  local cursor
  local g = c:geometry()
  local offset = 0
  local corner_coords
  local coordinates_delta = { x = 0, y = 0 }

  cursor = 'cross'
  if g.width + 15 >= wa.width then
    offset = g.width * 0.5
    cursor = 'sb_v_double_arrow'
  elseif not (g.x + g.width + 15 > wa.x + wa.width) then
    offset = g.width
  end
  corner_coords = { y = wa.y + wa.height * (1 - mwfact), x = g.x + offset }

  -- TODO why the fuck don't this work?
  if tile.resize_jump_to_corner then
    capi.mouse.coords(corner_coords)
  else
    local mouse_coords = capi.mouse.coords()
    coordinates_delta = {
      x = corner_coords.x - mouse_coords.x,
      y = corner_coords.y - mouse_coords.y,
    }
  end

  local prev_coords = {}
  capi.mousegrabber.run(function(_mouse)
    if not c.valid then return false end

    _mouse.x = _mouse.x + coordinates_delta.x
    _mouse.y = _mouse.y + coordinates_delta.y
    for _, v in ipairs(_mouse.buttons) do
      if v then
        prev_coords = { x = _mouse.x, y = _mouse.y }
        local fact_x = (_mouse.x - wa.x) / wa.width
        local fact_y = (_mouse.y - wa.y) / wa.height
        local new_mwfact

        local geom = c:geometry()

        -- we have to make sure we're not on the last visible
        -- client where we have to use different settings.
        local wfact
        local wfact_x, wfact_y
        if (geom.y + geom.height + 15) > (wa.y + wa.height) then
          wfact_y = (geom.y + geom.height - _mouse.y) / wa.height
        else
          wfact_y = (_mouse.y - geom.y) / wa.height
        end

        if (geom.x + geom.width + 15) > (wa.x + wa.width) then
          wfact_x = (geom.x + geom.width - _mouse.x) / wa.width
        else
          wfact_x = (_mouse.x - geom.x) / wa.width
        end

        if orientation == 'tile' then
          new_mwfact = fact_x
          wfact = wfact_y
        elseif orientation == 'left' then
          new_mwfact = 1 - fact_x
          wfact = wfact_y
        elseif orientation == 'bottom' then
          new_mwfact = fact_y
          wfact = wfact_x
        else
          new_mwfact = 1 - fact_y
          wfact = wfact_x
        end

        c.screen.selected_tag.master_width_factor = math.min(math.max(new_mwfact, 0.01), 0.99)
        client.setwfact(math.min(math.max(wfact, 0.01), 0.99), c)
        return true
      end
    end
    return prev_coords.x == _mouse.x and prev_coords.y == _mouse.y
  end, cursor)
end

local function do_tile(param)
  local workarea = param.workarea
  local clients = param.clients
  local tag = param.tag or capi.screen[param.screen].selected_tag
  local master_count = tag.master_count
  local master_width_factor = tag.master_width_factor

  -- TODO o redimensionamento horizontal está meio "lento"
  -- Se alterar o master_width_factor e ficar alterando entre
  -- esse layout e o tile, por exemplo, vai ver que os tamanhos
  -- são diferentes. Além disso, usar o mouse pra redimensionar
  -- é meio esquisito, ele cresce/diminui meio lento.

  if #clients == 0 then return end

  if master_count == 0 or master_count == #clients then
    for i = 1, #clients do
      param.geometries[clients[i]] = {
        x = workarea.x,
        y = workarea.y,
        width = workarea.width,
        height = workarea.height,
      }
    end
    return
  end

  local master_height = workarea.height / master_count
  local master_width = (master_count == #clients and workarea.width or workarea.width / 2)
  master_width = master_width * (master_width_factor + 1 / 2)
  for i = 1, master_count do
    param.geometries[clients[i]] = {
      x = workarea.x,
      y = workarea.y + master_height * (i - 1),
      width = master_width,
      height = master_height,
    }
  end

  local client_width = workarea.width - master_width
  for i = master_count + 1, #clients do
    param.geometries[clients[i]] = {
      x = master_width,
      y = workarea.y,
      width = client_width,
      height = workarea.height,
    }
  end
end

function tile.skip_gap(nclients, t)
  return nclients == 1 and t.master_fill_policy == 'expand'
end

--- The main tile algo, on the right.
-- @param screen The screen number to tile.
-- @clientlayout awful.layout.suit.tile.right
tile = {}
tile.name = 'limitedtile'
tile.arrange = do_tile
tile.skip_gap = tile.skip_gap
function tile.mouse_resize_handler(c, corner, x, y)
  return mouse_resize_handler(c, corner, x, y)
end

return tile
