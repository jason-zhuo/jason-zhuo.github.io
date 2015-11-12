#!/bin/bash
echo -n "Enter comment:"
read  comment

filesd=`git status | grep deleted | awk '{print \$2}'`
if [ "${filesd}" == "" ]; then
	  echo "nothing to remove"
	else
        for var in $filesd
        do
            #echo $var
            git rm --cached $var
        done
fi

filea=`git status -s | grep ?? | awk '{print \$2}'`
if [ "${filea}" == "" ]; then
	  echo "nothing to add"
	else
        for var in $filea
        do
            #echo $var
            sudo git add $var
        done
fi

filesm=`git status -s | grep M | awk '{print \$2}'`
if [ "${filesm}" == "" ]; then
	  echo "nothing to modify"
	else
        for var in $filesm
        do
            #echo $var
            sudo git add $var
        done
fi

#git commit -m "$comment"
#git push origin master
exit 0
