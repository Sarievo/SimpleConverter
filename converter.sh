#!/usr/bin/bash

re_def="^[a-z]+_to_[a-z]+$"
re_num="^-?(0|[1-9][0-9]*)(\.[0-9]+)?$"

echo "Enter a definition:"
read -a user_input
arr_length="${#user_input[@]}"
definition="${user_input[0]}"
constant="${user_input[1]}"

if [ "$arr_length" -eq "2" ] \
    && [[ "$definition" =~ $re_def ]] \
    && [[ "$constant" =~ $re_num ]]; then
  echo "The definition is correct!"
else
  echo "The definition is incorrect!"
fi
