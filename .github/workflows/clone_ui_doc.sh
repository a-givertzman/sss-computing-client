#!/bin/bash

#
# Script clones only part of submodule with
# documentation that relates to interface
#
# To run it use `./.github/workflows/clone_ui_doc.sh` from project root.
#

git submodule update --init --depth=1 -- assets/info
git -C assets/info config core.sparseCheckout true
mkdir -p .git/modules/assets/info/info && \
    echo -e '!/*\n/docs/\n/README.md' >> .git/modules/assets/info/info/sparse-checkout
git submodule update --init --force --checkout -- assets/info