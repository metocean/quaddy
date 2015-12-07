# Quaddy
Store, process and query a pre-allocated quadtree. Takes up lots of memory! level 9 is about 500mb.

```js
var quaddy = require('quaddy');
var lnglattotile = require('lnglattotile');
var quadtree = quaddy.preallocate(9);

var coordinates = {
  lng: [-165.92, ...],
  lat: [-78.48, ...]
};

for (var i = 0; i < coordinates.lng; i++) {
  var tile = lnglattotile(coordinates.lng[i], coordinates.lat[i], 9);
  var bin = quadtree.assert(tile[0], tile[1], tile[2]);
  if (bin.count == null)
    bin.count = 0;
  bin.count++;
  if (bin.indexes == null)
    bin.indexes = [];
  bin.indexes.push(i);
}

quadtree.visit(8, 0, function(x, y, z) {
  var count = 0;
  var tiles = quaddy.down(x, y, z);
  for (i = 0, i < tiles.length; i++) {
    var node = quadtree.get(tiles[i][0], tiles[i][1], tiles[i][2]);
    if (node == null)
      continue;
    count += node.count;
  }
  if (count == 0)
    return;
  var bin = quadtree.assert(x, y, z);
  bin.count = count;
});

var site = [coordinates.lon[0], coordinates.lat[0]];
var tile = lnglattotile(coordinates.lon[0], coordinates.lat[0], 9);

console.log(quadtree.get(tile[0], tile[1], tile[2]));

console.log(quadtree.get(0, 0, 1).count);
console.log(quadtree.get(1, 0, 1).count);
console.log(quadtree.get(1, 1, 1).count);
console.log(quadtree.get(0, 1, 1).count);
```