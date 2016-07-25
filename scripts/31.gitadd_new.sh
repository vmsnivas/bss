#!/bin/bash

A=`git s | grep '^A\|^AM\|^AR\|^AD^ A' | awk '{print $2}'`
U=`git s | grep ^? | awk '{print $2}'`
M=`git s | grep '^M\|^MA\|^MR\|^MM\|^MD\|^ M' | awk '{print $2}'`
R=`git s | grep '^R\|^RA\|^RM\|^RR\|^RD\|^ R' | awk '{print $4}'`
D=`git s | grep '^D\|^ D' | awk '{print $2}'`

function add {
	for i in $A
	do
		echo "Adding $i to staging..."
		git add $i
	done
}

function stgnew {
	for i in $U
	do
		echo "Adding $i to staging..."
		git add $i
	done
}

function modify {
	for i in $M
	do
		echo "Modifying $i and staging..."
		git add $i
	done
}

function rename {
	R1=`git s | grep ^R | awk '{print $2}'`
	R2=`git s | grep ^R | awk '{print $4}'`
	for i in $R
	do
		echo "Renaming/Moving $R1 to $R2 and staging..."
		git add $R2
	done
}

function delete {
	for i in $D
	do
		echo "Removing $i ..."
		git add $i
	done
}

if [[ -z $(git s) ]]
then
	echo "There are neither additions nor deletions to stage"
else
	for i in A M D R U
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
fi

# END
# Testing addition
