#!/bin/bash

# GIT Alias to status
git config --global alias.s "status -s"

A=`git s | grep '^A\|^AM\|^AR\|^AD^ A' | awk '{print $2}'`
U=`git s | grep ^? | awk '{print $2}'`
M=`git s | grep '^M\|^MA\|^MR\|^MM\|^MD\|^ M' | awk '{print $2}'`
R=`git s | grep '^R\|^RA\|^RM\|^RR\|^RD\|^ R' | awk '{print $4}'`
D=`git s | grep '^D\|^ D' | awk '{print $2}'`

function add {
	for i in `echo $A`
	do
		MSG=$(echo "Added $i")
		git add $i
		git commit -m $MSG
	done
}

function stgnew {
	for i in `echo $U`
	do
		MSG=$(echo "Added $i")
		git add $i
		git commit -m $MSG
	done
}

function modify {
	for i in `echo $M`
	do
		MSG=$(echo "Modified $i")
		git add $i
		git commit -m $MSG
	done
}

function rename {
	for i in `echo $R`
	do
		R1=`git s | grep $i | awk '{print $2}'`
		R2=`git s | grep $i | awk '{print $4}'`
		MSG=$(echo "Renamed/Moved $R1 to $R2")
		git add $R2
		git commit -m $MSG
	done
}

function delete {
	for i in `echo $D`
	do
		MSG=$(echo "Removed $i")
#		git add $i
		git commit -m $MSG
	done
}

if [[ -z $(git s) ]]
then
	echo "There are neither additions nor deletions to stage"
else
	for i in A U M R D
	do
		case $i in
		A)
			add
		;;
		U)
			stgnew
		;;
		M)
			modify
		;;
		R)
			rename
		;;
		D)
			delete
		;;
		esac
	done
	git push -fu origin master
fi

# END
