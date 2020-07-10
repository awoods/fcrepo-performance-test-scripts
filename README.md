# Fedora Performance Test Scripts

All scripts produce usage text when run without any arguments.

## Inventory of Scripts

1. [n-binaries.sh](https://github.com/fcrepo4-labs/fcrepo-performance-test-scripts/blob/master/n-binaries.sh)
   - Tests time to stage x-number of binaries and upload them
   - Test could be improved by only measuring upload time
1. [n-children.sh](https://github.com/fcrepo4-labs/fcrepo-performance-test-scripts/blob/master/n-children.sh)
   - Creates x-number of child containers
   - Tests time to to retrieve the parent container
1. [n-memberof.sh](https://github.com/fcrepo4-labs/fcrepo-performance-test-scripts/blob/master/n-memberof.sh)
   - Can not yet run against Fedora 6: Indirect containers not supported by F6 yet
1. [n-members.sh](https://github.com/fcrepo4-labs/fcrepo-performance-test-scripts/blob/master/n-members.sh)
   - Can not yet run against Fedora 6: Indirect containers not supported by F6 yet
1. [n-properties.sh](https://github.com/fcrepo4-labs/fcrepo-performance-test-scripts/blob/master/n-properties.sh)
   - Creates one resource with x-number of properties
   - Tests time to to retrieve the container with the properties
1. [n-uris.sh](https://github.com/fcrepo4-labs/fcrepo-performance-test-scripts/blob/master/n-uris.sh)
   - Similar to n-properties.sh, except the property is a link to a fake URL
1. [run-all.sh](https://github.com/fcrepo4-labs/fcrepo-performance-test-scripts/blob/master/run-all.sh)
   - Not used
