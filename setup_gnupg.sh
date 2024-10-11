#!/bin/bash

# Import GnuPG pubkeys / public keyrings

# Download and import `tarent-everyone.gpg` public keyring
# See also <https://confluence.tarent.de/pages/viewpage.action?pageId=592937048&focusedCommentId=1470595110#comment-1470595110>
curl https://tarentpgp.tarent.de/tarent-everyone.gpg | gpg -q --import - &> /dev/null
