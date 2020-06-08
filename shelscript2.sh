#!/usr/bin/env bash

git checkout maintenance
revision=`git log -1 | grep commit`
mergeRev=`echo $revision | cut -d " " -f 2`
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
echo "REL-30226 : merging changesets from maintenance-promotion and updating versions" >> commit.txt
git commit -F commit.txt
commit=`git log $start_rev..HEAD | egrep "^ *CAL" | grep -v "Merge branch " | grep -v "Merge remote-tracking branch" | grep -v "Rebase and Deliver" | sort -u`
echo `git push`