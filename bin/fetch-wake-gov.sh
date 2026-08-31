#!/bin/bash
set -e -u -o pipefail
set -x
zero=$(readlink -f "$0")
zerodir="${zero%/*}"
mirrordir="${zerodir}/../web-mirror/wake.gov"
Main(){
    rc=0
    wget --timestamping --force-directories --no-verbose --input-file=<(Files) --directory-prefix="$mirrordir" --compress=gzip --level=1 --no-parent --recursive --execute robots=off || rc="$?"
    [ "$rc" == 0 ] || [ "$rc" == 8 ]
    
    exit 0
}
Files(){
cat << EEOOTT
https://services.wake.gov/realdata_extracts/
https://services.wake.gov/collection_extracts/
https://s3.us-west-1.amazonaws.com/wakegov.com.if-us-west-1/s3fs-public/documents/2026-08/June%202026%20Permit%20Report.xlsx
EEOOTT
}
#$ wget --quiet --recursive --level=1 --no-parent --directory-prefix=approved-capture https://archive.example.net/exports/
# shellcheck disable=SC2317 # Typical pattern to make safe on NFS
Main "$@"
exit 1
