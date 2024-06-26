#!/usr/bin/env bash
#
# Massimo Lauria, 2024
#
# query all of your firefox bookmarks by tag, title or url
# idea from https://junegunn.kr/2015/04/browsing-chrome-history-with-fzf/
# mixed with my other old selector for pinboard

sqlitesep='{::}'


unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     opencmd=xdg-open;;
    Darwin*)    opencmd=open;;
    *)          opencmd=xdg-open
esac



# this is rarely locked but still, safety first
cp ~/.mozilla/firefox/*/weave/bookmarks.sqlite /tmp


sqlite3 -separator $sqlitesep /tmp/bookmarks.sqlite \
        '
          SELECT DATE(ROUND(i.dateAdded / 1000), "unixepoch","localtime") as MYDATE,
                 REPLACE(GROUP_CONCAT(t.tag), ",", ", "),
                 i.title, u.url
          FROM items i  JOIN urls u ON i.urlId = u.id  LEFT OUTER JOIN tags t ON i.id = t.itemId
          GROUP BY t.itemId
          ORDER BY MYDATE DESC
        ' |
    awk -F $sqlitesep '{printf "\x1b[36m%-'$cols's\t\x1b[33m%-'$cols's\t\x1b[m%-'$cols's\t---\t\x1b[34m%-'$cols's\n", $1, $2, $3, $4}' |
    fzf --query="$@" -e -i --ansi --reverse -m \
        --tabstop=4 -d '\t' \
        --prompt='Bookmarks> ' \
        --preview-window down:6:wrap --bind '?:toggle-preview,ctrl-s:toggle-sort' \
        --preview 'echo {1} "--- "{2}"\n\n"{3}"\n\nURL: "{5}' |
    grep -oP 'https?://.*$' | xargs ${opencmd}
