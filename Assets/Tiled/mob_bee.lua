return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.2",
  name = "mob_bee",
  class = "",
  tilewidth = 18,
  tileheight = 10,
  spacing = 0,
  margin = 0,
  columns = 4,
  image = "sprite/Bee/bee_simple.png",
  imagewidth = 72,
  imageheight = 10,
  objectalignment = "unspecified",
  tilerendersize = "tile",
  fillmode = "stretch",
  tileoffset = {
    x = 0,
    y = 0
  },
  grid = {
    orientation = "orthogonal",
    width = 18,
    height = 10
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
        id = 2,
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
            id = 1,
            name = "",
            type = "",
            shape = "rectangle",
            x = 0,
            y = 0,
            width = 18,
            height = 10,
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
          duration = 120
        },
        {
          tileid = 1,
          duration = 120
        },
        {
          tileid = 2,
          duration = 120
        },
        {
          tileid = 3,
          duration = 120
        }
      }
    }
  }
}
