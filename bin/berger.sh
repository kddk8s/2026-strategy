!/bin/bash
set -e -u -o pipefail
set -x
zero=$(readlink -f "$0")
zerodir="${zero%/*}"
root="${zerodir%/*}"

# Analytics due to the Phil Berger/Sam Page contested primary
# NCGA redistricted in October of 2025 per Trump's orders
# We have sample ballots from NCSBE's ballot bucket
# We have voter snapshots from 20250909, 20251007, 20251107, 20260101, and 20260303
# We want to know
#   * Whether there was a primary in 2024
#     * No
#   * Which voters (especially GOP leaning) were pulled from NC Senate district 26
#   * Which precincts for NC Senate district 26 has multiple senate seats
#   * Which voters for NC Senate district 26 voted this primary
#
#
Main() {
	Primaries
	Precincts
	exit 0
}
Primaries() {
	sqlite3 "$root/analytics/load/candidates/Candidate_listing_2010.sqlite3" "SELECT distinct election_dt, name_on_ballot, street_address, zip_code, party_candidate FROM candidate WHERE contest_name = 'NC SENATE DISTRICT 26';"
	sqlite3 "$root/analytics/load/candidates/Candidate_listing_2012.sqlite3" "SELECT distinct election_dt, name_on_ballot, street_address, zip_code, party_candidate FROM candidate WHERE contest_name = 'NC STATE SENATE DISTRICT 26';"
	sqlite3 "$root/analytics/load/candidates/Candidate_Listing_2014_rev1.sqlite3" "SELECT distinct election_dt, name_on_ballot, street_address, zip_code, party_candidate FROM candidate WHERE contest_name = 'NC STATE SENATE DISTRICT 26';"
	sqlite3 "$root/analytics/load/candidates/Candidate_Listing_2016.sqlite3" "SELECT distinct election_dt, name_on_ballot, street_address, zip_code, party_candidate FROM candidate WHERE contest_name = 'NC STATE SENATE DISTRICT 26';"
	sqlite3 "$root/analytics/load/candidates/Candidate_Listing_2018.sqlite3" "SELECT distinct election_dt, name_on_ballot, street_address, zip_code, party_candidate FROM candidate WHERE contest_name = 'NC STATE SENATE DISTRICT 30';"
	sqlite3 "$root/analytics/load/candidates/Candidate_Listing_2020.sqlite3" "SELECT distinct election_dt, name_on_ballot, street_address, zip_code, party_candidate FROM candidate WHERE contest_name = 'NC STATE SENATE DISTRICT 30';"
	sqlite3 "$root/analytics/load/candidates/Candidate_Listing_2022.sqlite3" "SELECT distinct election_dt, name_on_ballot, street_address, zip_code, party_candidate FROM candidate WHERE contest_name = 'NC STATE SENATE DISTRICT 26';"
	sqlite3 "$root/analytics/load/candidates/Candidate_Listing_2024.sqlite3" "SELECT distinct election_dt, name_on_ballot, street_address, zip_code, party_candidate FROM candidate WHERE contest_name = 'NC STATE SENATE DISTRICT 26';"
	sqlite3 "$root/analytics/load/candidates/Candidate_Listing_2026.sqlite3" "SELECT distinct election_dt, name_on_ballot, street_address, zip_code, party_candidate FROM candidate WHERE contest_name = 'NC STATE SENATE DISTRICT 26';"
}
Precincts() {
	sqlite3 "$root/berger-precints.sqlite3" -echo -init <(PrecinctExternal) << EEOOTT
.timer on
.echo on
CREATE TABLE IF NOT EXISTS nc_sen_precincts AS SELECT DISTINCT
  snapshot_dt
, county_desc
, precinct_desc
, vtd_desc FROM (
SELECT * FROM l_vrsnapshot20250909
UNION SELECT * FROM l_vrsnapshot20251007
UNION SELECT * FROM l_vrsnapshot20251104
UNION SELECT * FROM l_vrsnapshot20260101
UNION SELECT * FROM l_vrsnapshot20260303
) where nc_senate_abbrv='26';
CREATE TABLE IF NOT EXISTS nc_sen_voters AS SELECT
* FROM (
SELECT * FROM l_vrsnapshot20250909
UNION SELECT * FROM l_vrsnapshot20251007
UNION SELECT * FROM l_vrsnapshot20251104
UNION SELECT * FROM l_vrsnapshot20260101
UNION SELECT * FROM l_vrsnapshot20260303
) NATURAL JOIN (
SELECT DISTINCT county_desc, precinct_desc, vtd_desc FROM nc_sen_precincts
);
EEOOTT
}
PrecinctExternal() {
	cat << EEOOTT
ATTACH DATABASE '$root/analytics/load/snapshots/VR_Snapshot_20250909.sqlite3' AS s20250909;
ATTACH DATABASE '$root/analytics/load/snapshots/VR_Snapshot_20251007.sqlite3' AS s20251007;
ATTACH DATABASE '$root/analytics/load/snapshots/VR_Snapshot_20251104.sqlite3' AS s20251104;
ATTACH DATABASE '$root/analytics/load/snapshots/VR_Snapshot_20260101.sqlite3' AS s20260101;
ATTACH DATABASE '$root/analytics/load/snapshots/VR_Snapshot_20260303.sqlite3' AS s20260303;
.schema
EEOOTT
}
Main "$@"
exit 1
