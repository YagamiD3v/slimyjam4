return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.2",
  name = "mob_mushroom",
  class = "",
  tilewidth = 16,
  tileheight = 16,
  spacing = 0,
  margin = 0,
  columns = 4,
  image = "sprite/Mushroom/Mushroom_4/Mushroom_4_simple.png",
  imagewidth = 64,
  imageheight = 16,
  objectalignment = "unspecified",
  tilerendersize = "tile",
  fillmode = "stretch",
  tileoffset = {
    x = 0,
    y = 0
  },
  grid = {
    orientation = "orthogonal",
    width = 16,
    height = 16
  },
  properties = {},
  wangsets = {},
  tilecount = 4,
  tiles = {
    {
      id = 0,
      objectGroup = {
        type = "objectgroup",
        draworder = "index",
        id = 3,
        name = "",
        class = "",
        visible = true,
        opacity = 1,
        offsetx = 0,
        offsety = 0,
        parallaxx = 1,
        parallaxy = 1,
        properties = {},
        objects = {
          {
            id = 2,
            name = "",
            type = "",
            shape = "rectangle",
            x = 0,
            y = 0,
            width = 16,
            height = 16,
            rotation = 0,
            visible = true,
            properties = {
              ["isCollider"] = true
            }
          }
        }
      },
      animation = {
        {
          tileid = 0,
          duration = 150
        },
        {
          tileid = 1,
          duration = 150
        },
        {
          tileid = 2,
          duration = 150
        },
        {
          tileid = 3,
          duration = 150
        }
      }
    }
  }
}
