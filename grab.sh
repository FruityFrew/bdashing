#!/usr/bin/bash

# Expected behavour:
# 
# clip FILE    -> copy contents of FILE to clipboard
# clip FILE x  -> copy line x from FILE to clipboard
# clip FILE x y  -> copy lines x to y (inclusive) from FILE 
#           to clipboard

usage() {
  echo "Usage: $0 [-h] FILE [START] [END]"
  echo ""
  echo "Grab line(s) START (to END, if provided) from FILE and store in"
  echo "clipboard."
}


# Argument count check
if [[ $# -ne 1  &&  $# -ne 2  &&  $# -ne 3 || $1 == "-n" ]]; then
  usage
  exit 1
fi
# echo "CHECK 1  PASSED : Correct number of arguments"


FILE_NAME=$1
# File existence check
if [ -f ${FILE_NAME} ]; then
  FILE_PATH=$FILE_NAME
elif [ -f ${PWD}/${FILE_NAME} ]; then
  FILE_PATH=${CURRENT_DIR}/${FILE_NAME}
else
  echo "-clip: ${FILE_NAME}: No such file or directory"
  usage
  exit 1
fi
# echo "CHECK 2  PASSED : File exists at '${FILE_PATH}'"


START=$2
  END=$3
TOTAL=$(wc -l < $FILE_PATH)

if [ -z $START ]; then
  contents=$(sed -n 1,${TOTAL}p ${FILE_PATH})
elif [ -z $END ]; then
  contents=$(sed -n ${START}p ${FILE_PATH})
else
  contents=$(sed -n ${START},${END}p ${FILE_PATH})
fi
# echo "File contents:"
# echo "$contents"

# Pasting to Windows clipboard through clip.exe
echo $contents | clip.exe
exit 0
