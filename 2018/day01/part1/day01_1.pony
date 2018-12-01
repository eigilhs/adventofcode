use "files"
use "format"

actor Main
  new create(env: Env) =>
    let caps = recover val FileCaps.>set(FileRead).>set(FileStat) end
    var cur: I64 = 0

    try
      with file = OpenFile(
        FilePath(env.root as AmbientAuth, env.args(1)?, caps)?) as File
      do
        for line in file.lines() do
          cur = cur +? line.>strip("+").i64()?
        end
      end
      env.out.print(Format.int[I64](cur))
    end
