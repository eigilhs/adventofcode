import algorithm, math, sequtils, strutils

var a = "day02.input".readFile
  .splitLines[0..^2].mapIt(it.split('x').map(parseInt).sorted(cmp))

echo a.mapIt(3*it[0]*it[1] + 2*it[1]*it[2] + 2*it[0]*it[2]).sum()
echo a.mapIt(2*it[0] + 2*it[1] + it[0]*it[1]*it[2]).sum()
