# GDB startup code
set print pretty on
set print array  on
set print object on
set print static-members on
set print vtbl on
set print demangle on
set print sevenbit-strings off
set startup-with-shell off
set history save on
set pagination off
set confirm off

# Pretty printer for libstdc++
python
import sys
try:
  sys.path.insert(0, '/usr/share/gcc/python/')
  from libstdcxx.v6.printers import register_libstdcxx_printers
  register_libstdcxx_printers (None)
except ImportError:
  print("WARNING: libstdcxx pretty printers not found.")
  pass
end

# Pretty printer for libc++
python
import sys
import os.path
try:
  pp_path = os.path.expanduser('~/config/python/gdb_pprinter')
  sys.path.insert(0, pp_path)
  from libcxx.v1.printers import register_libcxx_printers
  register_libcxx_printers (None)
except ImportError:
  print("WARNING: libc++ pretty printers not found.")
  pass
end
