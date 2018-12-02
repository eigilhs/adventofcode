use "files"
use "format"
use "collections"

actor Main
  new create(env: Env) =>
    let caps = recover val FileCaps.>set(FileRead).>set(FileStat) end
    var a: USize = 0
    var b: USize = 0

    try
      with file = OpenFile(
        FilePath(env.root as AmbientAuth, env.args(1)?, caps)?) as File
      do
        for line in file.lines() do
          let bag = Bag[U8].>from((consume line).values())
          let vals = Set[USize].>union(bag.values())
          if vals.contains(2) then
            a = a + 1
          end
          if vals.contains(3) then
            b = b + 1
          end
        end
      end
      env.out.print(Format.int[USize](a * b))
    end

type Bag[A: (Hashable #read & Equatable[A] #read)] is HashBag[A, HashEq[A]]

class HashBag[A, H: HashFunction[A!] val] // is Comparable[HashBag[A, H] box]
  embed _map: HashMap[A!, USize, H]

  new create(prealloc: USize = 8) =>
    _map = _map.create(prealloc)

  fun ref set(value: A) =>
    _map(value) = try _map(value)? else 0 end + 1

  fun size(): USize =>
    _map.size()

  fun apply(value: box->A!): USize ? =>
    _map(value)?

  fun values(): MapValues[A!, USize, H, this->HashMap[A!, USize, H]]^ =>
    _map.values()

  fun ref from(iter: Iterator[A^]) =>
    while true do
      if iter.has_next() then
        try set(iter.next()?) else return end
      else
        return
      end
    end
