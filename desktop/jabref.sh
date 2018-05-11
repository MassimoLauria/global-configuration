#!/bin/sh

#
# Launcher for Jabref 4.2 under Ubuntu
#

# need java 8
export JAVA_HOME=/usr/lib/jvm/java-8-oracle

# setup (and fix) GTK look and feel
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel -Dswing.crossplatformlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel'

# exec
export JABREF=$HOME/.local/share/jabref/JabRef-4.2.jar
exec java -jar $JABREF
