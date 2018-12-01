use "collections"
use "files"
use "format"

actor Main
  new create(env: Env) =>
    let caps = recover val FileCaps.>set(FileRead).>set(FileStat) end
    var deltas = List[I64]

    try
      with file = OpenFile(
        FilePath(env.root as AmbientAuth, env.args(1)?, caps)?) as File
      do
        for line in file.lines() do
          deltas.push(line.>strip("+").i64()?)
        end
      end
    end
    var seen = Set[I64](deltas.size())
    var freq: I64 = 0
    while true do
      for delta in deltas.values() do
        seen.set(freq)
        try freq = freq +? delta else return end
        if seen.contains(freq) then
          env.out.print(Format.int[I64](freq))
          return
        end
      end
    end
