#!/bin/bash

#
# Script clones only part of submodule with
# documentation that relates to interface
#
# To run it use `./.github/workflows/clone_ui_doc.sh` from project root.
#

git submodule update --init --depth=1 -- assets/info
git -C assets/info config core.sparseCheckout true

config_dir=".git/modules/assets/info/info"

mkdir -p $config_dir && \
    echo -e '!/*' > "$config_dir/sparse-checkout" && \
    echo -e '/docs/' >> "$config_dir/sparse-checkout" && \
    echo -e '/reference/' >> "$config_dir/sparse-checkout" && \
    echo -e '/assets/image/' >> "$config_dir/sparse-checkout"
git submodule update --init --force --checkout -- assets/info

rm -rf assets/docs
rm -rf assets/reference
rm -rf  assets/image

mv -f assets/info/docs/ assets/docs
mv -f assets/info/assets/image/ assets/image
mv -f assets/info/reference/ assets/reference

rm -rf assets/info/docs/
rm -rf assets/info/reference/
rm -rf assets/info/assets/