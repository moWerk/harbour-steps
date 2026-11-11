#!/bin/bash
# Tag and publish a release: push main, tag vVERSION, create a GitHub
# pre-release with the app RPM, the sensorlogd RPM and the notes. The repo
# must exist (created by the author). usage: tools/release.sh VERSION NOTES.md
set -euo pipefail
cd "$(dirname "$0")/.."
v=${1:?version}; notes=${2:?notes file}
rpm=/mnt/storage/sailfish-sdk/out/harbour-steps/RPMS/harbour-steps-$v-1.aarch64.rpm
logd=$(ls -t /mnt/storage/sailfish-sdk/out/sensorlogd/RPMS/sensorlogd-*.aarch64.rpm | head -1)
[ -f "$rpm" ] || { echo "no RPM $rpm"; exit 1; }
git remote get-url origin >/dev/null 2>&1 || git remote add origin git@github.com:moWerk/harbour-steps.git
git push -u origin main
git tag -a "v$v" -m "Steps $v" 2>/dev/null || true
git push origin "v$v"
gh release create "v$v" "$rpm" "$logd" --prerelease --title "Steps $v" --notes-file "$notes"
