import md5

const s = "000000"

for n in 4..5:
  var i = 0
  var q = s[..n]
  while q != getMD5("bgvyzdsv" & $i)[..n]:
    inc i
  echo i
