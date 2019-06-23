#!/usr/bin/env python
"""
Python startup file for command line interpreter.
"""

# pythonstartup
import os
import atexit


# Bind 'TAB' to complete
try:
    import rlcompleter
    import readline
except ImportError:
    print("Readline not available")
else:
    # Tab completion
    readline.parse_and_bind("tab:complete")

    # Enable History File. Default at ~\.pythonhistory
    history_file = os.environ.get(
        "PYTHON_HISTORY_FILE", os.path.join(os.environ['HOME'],
        '.pythonhistory'))

    if os.path.isfile(history_file):
        readline.read_history_file(history_file)
    else:
        open(history_file, 'a').close()

    atexit.register(readline.write_history_file, history_file)

    del readline,rlcompleter

# Cleanup of the environment, do not pollute interpreter locals
del os
del atexit
