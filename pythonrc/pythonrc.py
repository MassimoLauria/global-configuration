#!/usr/bin/env python
"""
Python startup file for command line interpreter.
"""

# pythonstartup
import os
import atexit


# Persisten history file to  ~\.pythonhistory
histfile = os.path.join(os.environ['HOME'], ".pythonhistory")

# Bind 'TAB' to complete
try:
    import readline
except ImportError:
    print "Readline not available"
else:
    # Tab completion
    import rlcompleter
    readline.parse_and_bind("tab:complete")

    # Attempt read of histfile
    try:
        readline.read_history_file(histfile)
    except IOError:
        pass

# Write history file at shell exit
atexit.register(readline.write_history_file, histfile)

# Cleanup of the environment, do not pollute interpreter locals
del os, histfile, readline, rlcompleter
