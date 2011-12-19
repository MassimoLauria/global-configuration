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


def get_password(server, user=""):
    try:

        import keyring
        pwd = keyring.get_password(server, user)
        if not pwd:
            raise ValueError("No password in keyring.")
        else:
            return pwd

    except ImportError:
        print install_keyring_message
    except ValueError:
        print "No password found in the keyring."
    except:
        print "Problem in accessing the keyring. Is it loaded?"

    if os.isatty(sys.stdout.fileno()):
        print "We fallback to manual input."
        try:
            return getpass.getpass(prompt="Password: ")
        except:
            print "\nYou don't want to cooperate, I see. Bye bye."
            sys.exit(-1)
    else:
        print "Non-interactive shell. Can't ask to input password, sorry."
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
