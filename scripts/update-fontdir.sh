#!/bin/sh

#
# Copy this script in the ~/.fonts folder under Linux, and run it
# every time you move fonts there in order to make them visible to the
# font system.
#


if [ ! -f $PWD/update-fontdir.sh ]; then
    echo "Please run the script in its own directory"
    exit 1
fi

echo "Update fonts.dir..."
mkfontdir .
echo "Update fonts.scale..."
mkfontscale .
echo "Update fc.cache-1..."
fc-cache .
echo "Bye bye"
