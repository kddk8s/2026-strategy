# 2026 Strategy

Political strategy for 2026

## 2026 NC Elections around Wake County

* [Candidate Filing](https://dl.ncsbe.gov/?prefix=Elections/2026/Candidate%20Filing/)

## 2026 Persons of Interest

## Usage

This assumes access to a Unixish environment with [mise-en-place](https://mise.jdx.dev/) installed/configured

### fetch-ncsbe-data

Downloads/updates the following from ncsbe

* Statewide Voter History
* Statewide Voter Roll
* Voter Roll Snapshots (--history)
* Precinct Street Ranges (--precinct)
* 2026 Candidate Filings
* All Candidate filings (--allfilings)

```
ncsbe-data [--historic] [--precinct] [--allfilings]
```
