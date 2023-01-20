#!/usr/bin/bash


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
  fi
done


# printf "%s\n" "${all_files[@]}"
# echo ""

for new_file in "$all_files"; do
  for checked_file in "$checked_files[@]"; do
    if areSame "$new_file" "$checked_file"; then
      repeated_files+=("$new_file")
      echo "Repeated: $new_file (of $checked_file)"
      break 1
    fi
  done
  
  if [[ "${#repeated_files[@]}" -eq "0" ]] || [[ "$new_file" -ne "${repeated_files[-1]}" ]]; then
    checked_files+=("$new_file")
  fi

  checked_files+=("$new_file")
done

printf "Checked files\n"
printf "%s\n" "${checked_files[@]}"


printf "\nRepeated files\n"
printf "%s\n" "${repeated_files[@]}"
