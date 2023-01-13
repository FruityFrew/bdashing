#!/usr/bin/bash
# 
# Script that pritns out a tree of files in a git-repo along with simple stats
# on changes done in each file.



tree_dfs () {
  local curr_dir="$1"
  local indent="$2"
  
  # echo $curr_dir
  
  local children=(`ls $curr_dir`)

  local last=$((${#children[@]}-1))

  for i in ${!children[@]}; do
    if [[ $i -ne $last ]]; then
      echo "${indent}├── ${children[$i]}"
    else
      echo "${indent}└── ${children[$i]}"
    fi
    
    if [[ -d "${curr_dir}/${children[$i]}" ]]; then
      if [[ $i -ne $last ]]; then
        tree_dfs "${curr_dir}/${children[$i]}" "$indent│   "
      else
        tree_dfs "${curr_dir}/${children[$i]}" "$indent    "
      fi
    fi
  done
}


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
  commit_info=`git show $commit_id --numstat --oneline | grep -Eo "[0-9]+\s[0-9]+\s[a-zA-Z0-9_\.\$]+$"`
  # echo ">${commit_info}"
  
  list=($commit_info)
  
  added=${list[0]}
  subbed=${list[1]}
  fname=${list[2]}
  # echo -e "${fname} [${GREEN}${added}${END}/${RED}${subbed}${END}]"
  # echo -e $RED $commit_info $END
  # echo ""
  # echo $commit_id
done

tree_dfs "/home/akhmed" ""
