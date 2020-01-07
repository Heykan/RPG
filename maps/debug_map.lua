return {
  version = "1.2",
  luaversion = "5.1",
  tiledversion = "1.3.1",
  orientation = "orthogonal",
  renderorder = "left-up",
  width = 20,
  height = 18,
  tilewidth = 32,
  tileheight = 32,
  nextlayerid = 5,
  nextobjectid = 1,
  properties = {},
  tilesets = {
    {
      name = "Forest_Tileset",
      firstgid = 1,
      filename = "Forest_Tileset.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 19,
      image = "images/tiles/Forest_Tileset.png",
      imagewidth = 639,
      imageheight = 544,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 323,
      tiles = {}
    },
    {
      name = "map_state",
      firstgid = 324,
      filename = "map_state.tsx",
      tilewidth = 32,
      tileheight = 32,
      spacing = 0,
      margin = 0,
      columns = 1,
      image = "../images/tiles/map_state.png",
      imagewidth = 32,
      imageheight = 32,
      tileoffset = {
        x = 0,
        y = 0
      },
      grid = {
        orientation = "orthogonal",
        width = 32,
        height = 32
      },
      properties = {},
      terrains = {},
      tilecount = 1,
      tiles = {}
    }
  },
  layers = {
    {
      type = "tilelayer",
      id = 1,
      name = "ground_1",
      x = 0,
      y = 0,
      width = 20,
      height = 18,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        21, 21, 21, 21, 21, 134, 21, 21, 21, 21, 21, 21, 21, 118, 156, 157, 155, 21, 21, 21,
        21, 21, 21, 21, 21, 153, 154, 154, 154, 154, 154, 154, 154, 155, 12, 85, 21, 21, 21, 21,
        21, 21, 21, 21, 21, 21, 21, 21, 21, 7, 8, 8, 8, 8, 47, 85, 21, 21, 21, 21,
        21, 21, 21, 21, 21, 21, 7, 8, 8, 30, 10, 21, 21, 21, 21, 85, 21, 21, 21, 21,
        21, 21, 21, 21, 21, 21, 45, 10, 21, 28, 21, 21, 21, 21, 21, 85, 21, 21, 21, 21,
        21, 21, 21, 21, 21, 21, 21, 21, 21, 28, 21, 21, 21, 21, 21, 83, 21, 21, 21, 21,
        21, 21, 21, 21, 21, 21, 21, 21, 21, 28, 21, 21, 21, 21, 21, 83, 21, 61, 62, 62,
        21, 21, 21, 21, 16, 21, 21, 21, 21, 50, 21, 21, 21, 21, 21, 102, 65, 98, 81, 81,
        21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 80, 81, 81,
        21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 48, 11, 10, 80, 81, 81,
        21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 50, 21, 80, 81, 81,
        21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 61, 62, 98, 81, 81,
        21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 80, 58, 59, 59, 60,
        21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 80, 77, 21, 21, 79,
        21, 21, 21, 21, 21, 21, 21, 61, 71, 65, 65, 65, 65, 65, 65, 72, 91, 65, 65, 72,
        21, 21, 21, 21, 61, 71, 65, 72, 108, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
        21, 21, 21, 21, 80, 82, 21, 21, 85, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21,
        21, 21, 21, 21, 80, 96, 97, 97, 109, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21, 21
      }
    },
    {
      type = "tilelayer",
      id = 2,
      name = "ground_2",
      x = 0,
      y = 0,
      width = 20,
      height = 18,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        192, 193, 192, 193, 194, 0, 149, 0, 0, 0, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        192, 193, 192, 193, 194, 149, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        192, 193, 192, 193, 194, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 232, 0, 0, 0,
        192, 193, 211, 212, 194, 0, 0, 0, 0, 57, 0, 0, 0, 0, 0, 0, 231, 232, 0, 0,
        192, 193, 192, 193, 194, 0, 0, 0, 128, 0, 0, 0, 0, 0, 0, 0, 195, 268, 196, 0,
        193, 193, 192, 193, 194, 0, 76, 0, 75, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 196,
        192, 193, 192, 193, 194, 76, 176, 177, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        192, 193, 192, 193, 194, 0, 195, 196, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 114, 0,
        192, 193, 192, 193, 194, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 151,
        211, 212, 211, 212, 213, 0, 0, 129, 0, 0, 95, 75, 0, 0, 0, 0, 0, 0, 0, 0,
        230, 230, 230, 231, 232, 0, 0, 0, 0, 95, 76, 0, 75, 0, 0, 0, 0, 0, 131, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 149, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 149, 0, 176, 177, 0, 0, 0, 176, 177, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 196, 0, 0, 0, 195, 196, 0,
        0, 0, 75, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 75, 0, 76, 0, 0, 176, 177, 0, 0, 76, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 149, 149, 0, 0, 0, 195, 196, 0, 0, 0, 0, 0, 130, 0, 0, 147, 0, 0, 0,
        0, 0, 0, 149, 0, 0, 0, 0, 0, 0, 0, 0, 130, 130, 0, 0, 0, 0, 0, 147
      }
    },
    {
      type = "tilelayer",
      id = 3,
      name = "ground_3",
      x = 0,
      y = 0,
      width = 20,
      height = 18,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 176, 214, 214, 215,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 176, 214, 215, 214, 215,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 176, 214, 215, 215, 215,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 195, 176, 214, 215, 215,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 172, 173, 174, 175, 0, 0, 176, 214, 215,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 191, 192, 193, 194, 0, 0, 195, 196, 195,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 210, 211, 212, 213, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 229, 230, 231, 232, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        174, 173, 173, 173, 173, 173, 173, 174, 175, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        192, 192, 192, 192, 192, 192, 192, 193, 194, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        211, 211, 211, 211, 211, 211, 211, 212, 213, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        230, 230, 230, 230, 230, 230, 230, 231, 232, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      id = 4,
      name = "collide_layer",
      x = 0,
      y = 0,
      width = 20,
      height = 18,
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      properties = {},
      encoding = "lua",
      data = {
        324, 324, 324, 324, 0, 324, 0, 0, 0, 0, 0, 0, 0, 324, 0, 324, 324, 324, 324, 324,
        324, 324, 324, 324, 0, 324, 324, 324, 324, 324, 324, 324, 324, 324, 0, 324, 324, 324, 324, 324,
        324, 324, 324, 324, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 324, 324, 324, 324, 324,
        324, 324, 324, 324, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 324, 324, 324, 324, 324,
        324, 324, 324, 324, 0, 0, 0, 0, 324, 0, 0, 0, 0, 0, 0, 324, 324, 324, 324, 324,
        324, 324, 324, 324, 0, 0, 0, 0, 0, 0, 0, 0, 324, 324, 0, 324, 0, 324, 324, 324,
        324, 324, 324, 324, 0, 0, 0, 0, 0, 0, 0, 0, 324, 324, 0, 324, 0, 324, 324, 324,
        324, 324, 324, 324, 0, 0, 324, 324, 0, 0, 0, 0, 324, 324, 0, 324, 324, 324, 324, 324,
        324, 324, 324, 324, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 324, 324, 324,
        324, 324, 324, 324, 0, 0, 0, 0, 0, 0, 324, 0, 0, 0, 0, 0, 0, 324, 324, 324,
        324, 324, 324, 324, 0, 0, 0, 0, 0, 324, 0, 0, 0, 0, 0, 0, 0, 324, 324, 324,
        324, 324, 324, 324, 324, 324, 324, 324, 0, 0, 0, 0, 0, 0, 0, 324, 324, 324, 324, 324,
        324, 324, 324, 324, 324, 324, 324, 324, 0, 0, 0, 0, 0, 0, 0, 324, 324, 324, 324, 324,
        324, 324, 324, 324, 324, 324, 324, 324, 0, 0, 0, 0, 324, 324, 0, 324, 324, 324, 324, 324,
        0, 0, 0, 0, 0, 0, 0, 324, 324, 324, 324, 324, 324, 324, 324, 324, 324, 324, 324, 324,
        0, 0, 0, 0, 324, 324, 324, 324, 324, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 324, 324, 324, 324, 324, 0, 0, 0, 0, 0, 0, 0, 324, 0, 0, 0,
        0, 0, 0, 0, 324, 324, 324, 324, 324, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 324
      }
    }
  }
}
