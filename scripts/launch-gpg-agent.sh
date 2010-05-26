#!/bin/sh

GINFO=$HOME/.gnupg/gpg-agent-info-$(hostname)

if test -f $GINFO &&
    kill -0 `cut -d: -f 2 $GINFO` 2>/dev/null; then
    GPG_AGENT_INFO=`cat $GINFO`
    export GPG_AGENT_INFO
else
    exec /usr/bin/gpg-agent --daemon \
        --write-env-file "$GINFO" "$@"
fi
