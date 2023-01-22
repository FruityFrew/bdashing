#!/usr/bin/bash
# 
# Script that pritns out a tree of files in a git-repo along with simple stats
# on changes done in each file.
#
# Author: Akhmed Al-Sayed
# Last update: 15/1/2023

tree () {
  local curr_dir="$1"
  local indent="$2"
  
  # echo $curr_dir
  
  local children=(`ls $curr_dir`)
  local last=$((${#children[@]}-1))

  local postfix=""

  for i in ${!children[@]}; do
    # Adding postfix to changed files
    if [[ "${files_changed[@]}" =~ (^|[[:space:]])${children[$i]}($|[[:space:]]) ]]; then
      for j in "${!files_changed[@]}"; do
        if [[ "${files_changed[$j]}" = "${children[$i]}" ]]; then
          postfix="[${GREEN}${greens_list[$j]}↑${END} ${RED}${reds_list[$j]}↓${END}]"
        fi
      done
    fi


    if [[ $i -ne $last ]]; then
      echo -e "${indent}├── ${children[$i]} ${postfix}"
    else
      echo -e "${indent}└── ${children[$i]} ${postfix}"
    fi
    
    if [[ -d "${curr_dir}/${children[$i]}" ]]; then
      if [[ $i -ne $last ]]; then
        tree "${curr_dir}/${children[$i]}" "$indent│   "
      else
        tree "${curr_dir}/${children[$i]}" "$indent    "
      fi
    fi
  done
}


# Colors for output
GREEN='\e[32m'
RED='\e[31m'
END='\e[0m'


# Depth history search (default: 5)
if [[ "$1" != "" ]] && [[ ! $1 =~ "[0-9]+$" ]]; then
  DEPTH=$(("$1"))
else
  DEPTH=5
fi


files_changed=()
greens_list=()
reds_list=()


commit_id_list=`git log -n ${DEPTH} | grep -E "commit\ [0-9a-f]{40}" | grep -oEw "[0-9a-f]{40}" --color=never`


for commit_id in $commit_id_list; do
  commit_info=`git show $commit_id --numstat --oneline | grep -Eo "[0-9]+\s[0-9]+\s[a-zA-Z0-9_\.\$]+$"`
  # echo ">${commit_info}"

  list=($commit_info)

  greens=${list[0]}
  reds=${list[1]}
  file_name="${list[2]}"


  if [[ "${files_changed[@]}" =~ (^|[[:space:]])${file_name}($|[[:space:]]) ]]; then
    for i in "${!files_changed[@]}"; do
      if [[ "${files_changed[$i]}" = "${file_name}" ]]; then
        greens_list[$i]=$((${greens_list[$i]} + $greens))
        reds_list[$i]=$((${reds_list[$i]} + $reds))
      fi
    done
    # echo "not new"
  else
    files_changed+=("${file_name}")
    greens_list+=($greens)
    reds_list+=($reds)
    # echo "new"
  fi
  # echo "List: ${files_changed[@]}" 
  # echo -e "${file_name} [${GREEN}${greens}${END}/${RED}${reds}${END}]"
  # echo -e $RED $commit_info $END
  # echo ""
  # echo $commit_id
done

tree "/srv/git/bdashing" ""
