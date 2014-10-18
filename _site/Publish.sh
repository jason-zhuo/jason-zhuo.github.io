#!/bin/bash
echo -n "Enter comment:"
read  comment
git add .
git commit -m $comment
git push origin master
exit 0                               
