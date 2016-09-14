##!/usr/bin/env python
# -*- coding:utf-8 -*-

from IPython import get_ipython
from prompt_toolkit.enums import DEFAULT_BUFFER
from prompt_toolkit.keys import Keys
from prompt_toolkit.filters import HasFocus, HasSelection, ViInsertMode, EmacsInsertMode

from prompt_toolkit.key_binding.bindings.named_commands import get_by_name
from prompt_toolkit.key_binding.bindings.scroll import scroll_backward,scroll_forward

ip = get_ipython()
insert_mode = EmacsInsertMode() | ViInsertMode()

# Register the shortcut if IPython is using prompt_toolkit
def bind(action,*keys):
    if isinstance(action,(str,unicode)):
        action = get_by_name(action)
    if getattr(ip, 'pt_cli'):
        registry = ip.pt_cli.application.key_bindings_registry
        registry.add_binding(*keys,filter=(HasFocus(DEFAULT_BUFFER)
                                           & ~HasSelection()
                                           & insert_mode))(action)



def kill_whole_line(event):
    " Kill the whole line"
    buff = event.current_buffer

    deletedBefore = buff.delete_before_cursor(count=-buff.document.get_start_of_line_position())
    deletedAfter  = buff.delete(count=buff.document.get_end_of_line_position())

    if buff.document.current_char == '\n':
        deletedNL = buff.delete(1)
    else:
        deletedNL = ""
    event.cli.clipboard.set_text(deletedBefore+deletedAfter+deletedNL)

        
######################################
#                                    #
#   Basic Keyboard Key settings      #
#                                    #
######################################

# Rationale
#
# j = Left
# l = Right
# i = Up
# k = Down
#
# o = End
#
# b = Prev
# n = Next

# Arrows on home row
bind("backward-char",Keys.Escape,u"j")
bind("forward-char",Keys.Escape,u"l")
bind("previous-history",Keys.Escape,u"i")
bind("next-history",Keys.Escape,u"k")

# Word jumps
bind("backward-word",Keys.Escape,u"u")
bind("forward-word",Keys.Escape,u"o")

# Home/End on home row
bind("beginning-of-line",Keys.Escape,u"g")
bind("end-of-line",Keys.Escape,u"e")

# Paragraphs
bind(scroll_backward,Keys.Escape,u"b")
bind(scroll_forward,Keys.Escape,u"n")

# # Prev/Next close to home row
# M-b: history-search-backward
# M-n: history-search-forward



# ##################
# # Deletion keys  #
# ##################
bind("backward-delete-char", Keys.Escape,u"d")
bind("delete-char",          Keys.Escape,u"f")
bind("backward-kill-word",   Keys.Escape,u"e")
bind("kill-word",            Keys.Escape,u"r")
bind(kill_whole_line,        Keys.Escape,u"w")

# ##################
# # Cut/Paste/Undo #
# ##################
bind("yank",       Keys.ControlV)
bind("yank-pop",   Keys.Escape,u"y")
bind("undo",       Keys.ControlZ)
# Missing....
# M-x: kill-region
# M-c: copy-region-as-kill
# M-y: yank-pop
# M-SPC: set-mark
