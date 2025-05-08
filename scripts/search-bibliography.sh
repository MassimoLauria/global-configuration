#!/bin/sh

#
# Shell command to open a PDF looking among by bibtex entries
#

LS=bibtex-ls
BIBFILE=$HOME/lavori/latex/bibliografia.bib
PAPERSDIR=$HOME/cloud/Papers

unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     opencmd=xdg-open
                grepcmd=grep
                ;;
    Darwin*)    opencmd=open
                grepcmd=ggrep
                ;;
    *)          opencmd=xdg-open
                grepcmd=grep
esac


_bib_check_runtime() {
    local fail=0

    type $LS >/dev/null 2>&1 ||
        { echo >&2 "Required '$(basename $LS)' command is missing. Run ";
          echo >&2 "    $ go get github.com/msprev/fzf-bibtex/cmd/bibtex-ls"
          echo >&2 "    $ go install github.com/msprev/fzf-bibtex/cmd/bibtex-ls"
          fail=1; }

    type fzf >/dev/null 2>&1 ||
        { echo >&2 "Required 'fzf' command is missing."; fail=1; }

    type $grepcmp >/dev/null 2>&1 ||
        { echo >&2 "You miss '$grepcmd'. Maybe you need gnu grep on MacOSX?."; fail=1; }

    return $fail
}


_bib_check_runtime || exit 1

# Initial query
query=""

if [ "$#" -ge 1 ]; then
    query="-q $@"
fi

# Choose file and build command line
selected=$($LS $BIBFILE | fzf -d'@' \
                   --preview "bibtool -- select\{\\\$key\\ \\\"^{2}\\\$\\\"\} -q -i $BIBFILE 2>/dev/null" \
                   --preview-window down:wrap \
                   --bind '?:toggle-preview' \
                   -e --reverse --ansi $query | cut -d@ -f2 )

if [ -z "$selected" ]; then
    exit 1
fi

fileline=$(awk 'BEGIN {RS="\n@"} /'$selected'/{print "@" $0}' $BIBFILE |
                     $grepcmd -Po 'file\s*=\s*{\K[^}]*' )

case "$fileline" in
  *:PDF*)
    filename=$(echo $fileline|cut -d: -f2)
    ;;
  *)
    filename=$fileline
    ;;
esac

if [ -z "$filename" ]; then
    echo "No file associated to entry [$selected]"
else
    $opencmd "$PAPERSDIR/$filename" &
fi
