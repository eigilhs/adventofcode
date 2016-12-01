import basic2d, sets

let s = readFile "day03.input"

for j in 1..2:
  var loc = [new(ref Point2d), new(ref Point2d)]
  var p = initSet[string]()
  p.incl("0,0")
  for i, m in s:
    var sr = loc[i mod j]
    case m:
      of '>':
        sr[].move(1, 0)
      of '<':
        sr[].move(-1, 0)
      of '^':
        sr[].move(0, 1)
      of 'v':
        sr[].move(0, -1)
      else:
        discard
    p.incl($sr[])
  echo len p
