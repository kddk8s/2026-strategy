#!/bin/bash
set -e -u -o pipefail
set -x
zero=$(readlink -f "$0")
zerodir="${zero%/*}"
mirrordir="${zerodir}/../web-mirror/wake.gov"
Main(){
    wget --timestamping --force-directories --no-verbose --input-file=<(Files) --directory-prefix="$mirrordir" --compress=gzip
    
    exit 0
}
Files(){
cat << EEOOTT
https://github.com/kddk8s/2026-strategy.git
https://services.wake.gov/realdata_extracts/2026_Residential_Report.xlsx
https://services.wake.gov/realdata_extracts/PhyAddr_TabDelmTxtFile.txt
https://services.wake.gov/realdata_extracts/RealEstData08292026.xlsx
EEOOTT
}
# shellcheck disable=SC2317 # Typical pattern to make safe on NFS
Main "$@"
exit 1
