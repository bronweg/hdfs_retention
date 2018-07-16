#!/bin/bash

hdfs_path=$1
retention=$2
num='^[0-9]+$'

help() {
cat << EOF
	Usage: $0 <HDFS path> <number of days>

	This is an HDFS retention polycy script.

	The script got exactly two arguments:
	1. HDFS folder path as first argument
	2. Number of days as second argument

	And deleting folders in the <HDFS path> that older than <number of days>

	Example:
	Delete HIVE tables older than 10 days
	$0 /user/hive/warehouse 30

	Wrote by Ulis Ilya ulis.ilya@gmail.com
	Reference: https://stackoverflow.com/questions/44235019/delete-files-older-than-10days-on-hdfs
EOF
}
if [[ $1 == "--help" ]] || [[ $1 == -h ]]; then
	help
	exit 0
elif [[ $# -ne 2 ]]; then
	echo "Error! You should provide exact two arguments."
	help
	exit 1
elif [[ -z $(hdfs dfs -ls $hdfs_path 2>/dev/null) ]]; then
	echo "Error! First argument should be a path. Path $hdfs_path does not exist."
	help
	exit 1
elif [[ ! $retention =~ $num ]]; then
	echo "Error! Second argument '${retention}' should be a number."
	help
	exit 1
fi

today=$(date +'%s')
hdfs dfs -ls ${hdfs_path} | grep "^d" | \
while read line ; do
	dir_date=$(echo ${line} | awk '{print $6}')
	difference=$(( ( ${today} - $(date -d ${dir_date} +%s) ) / ( 24*60*60 ) ))
	filePath=$(echo ${line} | awk '{print $8}')
	if [ ${difference} -gt ${retention} ]; then
		echo "hdfs dfs -rm -r $filePath"
	fi
done
