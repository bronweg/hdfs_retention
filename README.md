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

