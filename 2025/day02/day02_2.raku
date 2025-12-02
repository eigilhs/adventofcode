say [+] slurp.&{m:g/(\d+)\-(\d+)/}».&{|Range.new(|$_).grep: /^(\d+)$0+$/}
