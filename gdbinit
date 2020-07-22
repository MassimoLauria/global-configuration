# Load pretty printers for either
#
#  - libc++/clang/macosx
#  - libstdc++/gcc/linux
#
python

import sys
from os.path import expanduser,join

pprinter_path = 'config/python/gdb_pprinter/'

sys.path.insert(0, join(expanduser("~"),pprinter_path))

from libstdcxx.v6.printers import register_libstdcxx_printers
from libcxx.v1.printers import register_libcxx_printers

if sys.platform.startswith("linux"):
  register_libstdcxx_printers (None)
elif sys.platform.startswith("darwin"):
  register_libcxx_printers (None)

end

set print pretty on
set print array  on
set print object on
set print static-members on
set print vtbl on
set print demangle on
# set demangle-style gnu-v3
set print sevenbit-strings off
set startup-with-shell off
