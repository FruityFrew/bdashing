#!/usr/bin/bash
# 
# Script for removing repeated files from system.
# 
# Author: Akhmed Al-Sayed
# License: MIT


GREEN='\e[32m'
  RED='\e[31m'
  END='\e[0m'


areSame () {
  file_a="$1"
  file_b="$2"

  check=`cmp -s "$file_a" "$file_b" && "$file_a" -ne "$file_b" && echo "same" || echo "different"`

  
  if [[ $check == "same" ]]; then
    return 0
  else 
    return 1
  fi
}

if [ $# -eq 0 ]; then
  echo "No path supplied"
  exit 1
fi

# Remove '/' from the end of the path, if present
start_path=`echo ${1%/}`


if [ ! -d "$start_path" ]; then
  echo "Supplied input is not a path"
  exit 1
fi


all_files=()
checked_files=()
repeated_files=()

for entry in "$start_path"/*; do
  if [ -f "$entry" ]; then
    all_files+=("$entry")
    # echo "$entry"
  fi
done


printf "%s\n" "${all_files[@]}"
echo ""


for new_file in "${all_files[@]}"; do
  echo "Testing '$new_file'"
  for checked_file in "${checked_files[@]}"; do
    areSame "$new_file" "$checked_file"
    if [[ $? -eq 0 ]]; then
      repeated_files+=("$new_file")
      echo -e "${RED}${new_file}${END} (same as $checked_file)"
      break 1
    fi
    false
  done

  if [[ $? -eq 1 || ${#checked_files[@]} -eq 0 ]]; then
  # if [[ "${#repeated_files[@]}" -eq "0" ]] || [[ "$new_file" -ne "${repeated_files[-1]}" ]]; then
    echo -e "${GREEN}$new_file${END}"
    checked_files+=("$new_file")
  fi
done
echo ""
printf "Total files:    %s\n" "${#all_files[@]}"

printf "Unique files:   %s\n" "${#checked_files[@]}"
# printf "%s\n" "${checked_files[@]}"


printf "Repeated files: %s\n" "${#repeated_files[@]}"
printf "%s\n" "${repeated_files[@]}"
