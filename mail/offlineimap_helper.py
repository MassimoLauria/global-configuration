#!/usr/bin/python
# -*- coding: utf-8 -*-

import os
import sys
import getpass

install_keyring_message = """
Sorry. Python keyring manager is not installed.
We can't load password from the keyring.
Please run `sudo pip install keyring'
"""


def get_password(server):
    try:

        import keyring
        pwd = keyring.get_password(server,"")
        if not pwd:
            raise ValueError("Unable to load password.")
        else:
            return pwd

    except ImportError:
        print install_keyring_message
    except ValueError:
        pass

    print "Unable to load password from keyring."
    print "We try with user input, if possible."

    if os.isatty(sys.stdout.fileno()):
        return getpass.getpass(prompt="Password: ")
    else:
        print "Not in interactive shell. Can't read password."
        sys.exit(-1)


if __name__ == '__main__':
    try:
        import keyring
    except ImportError:
        print install_keyring_message
        sys.exit(-1)

    print "We memorize credential for the imap servers."

    server = raw_input("Imap server: ")
    username = raw_input("Username: ")
    # Query/verify password cycle
    while True:
        password = getpass.getpass(prompt="Insert password: ")
        retyped = getpass.getpass(prompt="Retype password: ")
        if  retyped != password:
            print "Passwords don't match."
        else:
            break

    print "Saving credential:"

    try:
        keyring.set_password(server, username, password)
        print "OK! Password saved."
    except keyring.backend.PasswordError:
        print "FAILED! Problem saving the password, sorry."
