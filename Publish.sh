#!/bin/bash
echo -n "Enter comment:"
read  comment
files=`git status | grep deleted | awk '{print \$2}'`
for var in $files
do
#		echo $var
	   git rm --cached $var
done
git add .
git commit -m "$comment"
git push origin master
exit 0                               
