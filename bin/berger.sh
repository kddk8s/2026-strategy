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
#   * Which voters (especially GOP leaning) were pulled from NC Senate district 26
#   * Which precincts for NC Senate district 26 has multiple senate seats
#   * Which voters for NC Senate district 26 voted this primary
#
#
Main() {
	Primaries
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
Main "$@"
exit 1
