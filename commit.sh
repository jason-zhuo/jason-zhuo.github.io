#!/bin/bash
echo -n "Enter comment:"
read  comment
files=`git status -s | grep ?? | awk '{print \$2}'`
if [ "${files}" == "" ]; then
	  echo "nothing to add"
	else
        for var in $files
        do
            #echo $var
            git add $var
        done
fi

git commit -m "$comment"
#git push origin master
exit 0
