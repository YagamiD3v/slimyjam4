return {
  version = "1.10",
  luaversion = "5.1",
  tiledversion = "1.10.2",
  name = "droplet",
  class = "",
  tilewidth = 16,
  tileheight = 16,
  spacing = 0,
  margin = 0,
  columns = 4,
  image = "object/droplet.png",
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
            x = 3.93985,
            y = 4.06015,
            width = 8.1203,
            height = 9.10244,
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
          duration = 170
        },
        {
          tileid = 1,
          duration = 170
        },
        {
          tileid = 2,
          duration = 170
        },
        {
          tileid = 3,
          duration = 170
        }
      }
    }
  }
}
