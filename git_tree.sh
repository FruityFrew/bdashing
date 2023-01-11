#!/usr/bin/bash
# 
# Script that pritns out a tree of files in a git-repo along with simple stats
# on changes done in each file.

# Colors for output
GREEN='\e[32m'
RED='\e[31m'
END='\e[0m'


# Default depth history search
DEPTH=5



files_changed=()
# count_added=()
# count_removed=()

is_new=()


commit_id_list=`git log | grep -E "commit\ [0-9a-f]{40}" | grep -oEw "[0-9a-f]{40}" --color=never`


# echo $commit_id_list


for commit_id in $commit_id_list; do
  commit_info=`git show $commit_id --numstat --oneline | grep -Eo "[0-9]*\s[0-9]*\s[a-zA-Z0-9]*\.*[a-zA-Z0-9]+$"`
  
  list=($commit_info)
  
  added=${list[0]}
  subbed=${list[1]}
  fname=${list[2]}
  # printf "${fname} [${GREEN}${added}${END}/${RED}${subbed}${END}]"
  echo -e $RED $commit_info $END
  echo ""
  # echo $commit_id
done


