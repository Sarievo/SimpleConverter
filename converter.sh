#!/usr/bin/bash
set -euo pipefail

re_def="^[a-z]+_to_[a-z]+$"
re_num="^-?(0|[1-9][0-9]*)(\.[0-9]+)?$"
re_dig="^[0-9]+$"


file_name="definitions.txt"


convert() {
  if ! [[ -f "$file_name" ]]; then
    echo "Please add a definition first!"
    return
  fi
  
  n_lines=0
  echo "Type the line number to convert units or '0' to return"
  while IFS= read -r line
  do
    ((n_lines=n_lines+1))
    echo "$n_lines. $line"
  done < "$file_name"

  read line_number
  while ! [[ "$line_number" =~ $re_dig ]] \
      || ! { [[ "$line_number" -ge "0" ]] && [[ "$line_number" -le "$n_lines" ]]; }; do
    echo "Enter a valid line number!"
    read line_number
  done

  if [[ "$line_number" == '0' ]]; then
    return
  else
    line=$(sed "${line_number}!d" "$file_name")
    read -a user_input <<< "$line"
    # definition="${user_input[0]}"
    constant="${user_input[1]}"

    echo "Enter a value to convert:"
    read value
    while ! [[ "$value" =~ $re_num ]]; do
      echo "Enter a float or integer value!"
      read value
    done
    result=$(echo "scale=2; $constant * $value" | bc -l)
    printf "Result: %s\n" "$result"
  fi
}

add_definition() {
  echo "Enter a definition:"
  read -a user_input
  arr_length="${#user_input[@]}"
  if [ "$arr_length" -eq "2" ]; then
    definition="${user_input[0]}"
    constant="${user_input[1]}"
  fi

  while ! { [ "$arr_length" -eq "2" ] \
      && [[ "$definition" =~ $re_def ]] \
      && [[ "$constant" =~ $re_num ]]; }; do
    printf "The definition is incorrect!\nEnter a definition:"
    read -a user_input
    arr_length="${#user_input[@]}"
    if [ "$arr_length" -eq "2" ]; then
      definition="${user_input[0]}"
      constant="${user_input[1]}"
    fi
  done

  echo "$definition $constant" >> "$file_name"
}

delete_definition() {
  if ! [[ -f "$file_name" ]]; then
    echo "Please add a definition first!"
    return
  fi
  
  n_lines=0
  echo "Type the line number to delete or '0' to return"
  while IFS= read -r line
  do
    ((n_lines=n_lines+1))
    echo "$n_lines. $line"
  done < "$file_name"

  read line_number
  while ! [[ "$line_number" =~ $re_dig ]] \
      || ! { [[ "$line_number" -ge "0" ]] && [[ "$line_number" -le "$n_lines" ]]; }; do
    echo "Enter a valid line number!"
    read line_number
  done

  if [[ "$line_number" == '0' ]]; then
    return
  else
    sed -i "${line_number}d" "$file_name"
  fi
}


printf "Welcome to the Simple converter!\n"
while true; do
  cat << EOF
Select an option
0. Type '0' or 'quit' to end program
1. Convert units
2. Add a definition
3. Delete a definition
EOF
  read choice
  case "$choice" in
    1)
      convert
      ;;
    2)
      add_definition
      ;;
    3)
      delete_definition
      ;;
    0 | quit)
      break
      ;;
    *)
      echo "Invalid option!"
      ;;
  esac
done
echo "Goodbye!"
