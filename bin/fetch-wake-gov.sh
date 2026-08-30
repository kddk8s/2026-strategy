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
https://services.wake.gov/realdata_extracts/2026_Residential_Report.xlsx
https://services.wake.gov/realdata_extracts/PhyAddr_TabDelmTxtFile.txt
https://services.wake.gov/realdata_extracts/RealEstData08292026.xlsx
https://services.wake.gov/collection_extracts/REAL_ESTATE_FULL853_08282026.XLSX
https://services.wake.gov/collection_extracts/REAL_ESTATE_delq853_08282026.xlsx
https://s3.us-west-1.amazonaws.com/wakegov.com.if-us-west-1/s3fs-public/documents/2026-08/June%202026%20Permit%20Report.xlsx
EEOOTT
}
# shellcheck disable=SC2317 # Typical pattern to make safe on NFS
Main "$@"
exit 1
