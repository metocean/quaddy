# A quad tree is defined as a subdividing 2d plane
# A single tile splits into four, each tile then spits into another four

# z = the subdivision level
# x, y = the coordinates of the tile in the level
# len = the number of tiles along one edge at a certain z level

# zmax is the maximum z level
module.exports =
  # Calculate the coordinates of the tile above
  up: (x, y, z) ->
    halfx = Math.floor x / 2
    halfy = Math.floor y / 2
    prevz = z - 1
    [halfx, halfy, prevz]

  # Calculate the four coodinates of the tiles below
  # In order: NW, NE, SE, SW
  down: (x, y, z) ->
    doublex = x * 2
    doubley = y * 2
    nextz = z + 1
    [
      [doublex, doubley, nextz]
      [doublex + 1, doubley, nextz]
      [doublex + 1, doubley + 1, nextz]
      [doublex, doubley + 1, nextz]
    ]

  # Create a preallocated tree, good for random access
  preallocate: (zmax) ->
    # create the tree structure
    levels = [0..zmax].map (z) ->
      len = Math.pow 2, z
      new Array len * len

    # Read a location from the quadtree, may be undefined
    get: (x, y, z) ->
      len = Math.pow 2, z
      levels[z][y * len + x]

    # Read if available or create if not available
    assert: (x, y, z) ->
      len = Math.pow 2, z
      if !levels[z][y * len + x]?
        levels[z][y * len + x] = {}
      levels[z][y * len + x]

    # Visit every node from zstart to zend
    visit: (zstart, zend, f) ->
      for z in [zstart..zend]
        widths = [0...Math.pow(2, z)]
        for y in widths
          for x in widths
            f x, y, z
      null

  # TODO: Proper lined quadtree?
