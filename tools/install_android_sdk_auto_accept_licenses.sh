#!/bin/bash
# Install all non-obsolete android sdk packages.
# author: Claudiu Chiticariu Constantin (chiticariu at gmail.com)

function install_sdk {
  android update sdk --all --no-ui --filter "$1"
}

function fetch_non_obsoled_package_indices {
  # Fetch the sdk list using non-https connections
  android list sdk -u -s -a |\
    # Filter obsoleted packages
    sed '/\(Obsolete\)/d' |\
    # Filter to take only the index number of package
    sed 's/^[ ]*\([0-9]*\).*/\1/' |\
    # Remove the empty lines
    sed -n 's/^[^ $]/\0/p'
}

function get_package_list_from_args {
  # Fetch the sdk list using non-https connections
  android list sdk -u -s -a |\
    # Filter obsoleted packages
    sed '/\(Obsolete\)/d' |\
    # Filter to take only the index number of package
    sed 's/^[ ]*\([0-9]*\).*/\1/' |\
    # Remove the empty lines
    sed -n 's/^[^ $]/\0/p'
}

for package_index in $(echo $1 | tr "," "\n")
do
  echo "====================================================================="
  echo "Start to install package:  ${package_index}"
  echo "====================================================================="
  # Auto accept license
  echo -e "y" | android update sdk --all --no-ui --filter "${package_index}"
  echo
  echo
done
