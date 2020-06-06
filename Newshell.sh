#!/usr/bin/env bash

git checkout maintenance
git pull
git checkout promotion-1610
git pull
revision=`git log -1 | grep commit`
start_rev=`echo $revision | cut -d " " -f 2`
echo "Revision before merging : $start_rev"
#merge and ensure no conflict
check2=$(git merge $mergeRev --no-commit 2>&1)
if [[ $check2 == *"conflict"* ]]; then
 echo "There's a conflct. Aborting..."
 exit 1
fi
check3=$(git diff $start_rev..HEAD | grep "\\-SNAPSHOT")
if [[ -n $check3 ]]; then
  echo "SNAPSHOT detected in merge. Please review"
  exit 1
fi
echo "REL-30226 : merging changesets from maintenance-promotion and updating versions" 
revision2=`git log -1 | grep commit`
end_rev=`echo $revision2 | cut -d " " -f 2`
echo "Revision after merging: $end_rev"
git merge remotes/origin/maintenance
git push
