#!/bin/bash

# This script count proccesses for a specific executable file
# options:
# -c <num> displays a limited number of times
# -t <num> timeout
# -u <user_name> displays proccesses for user_name

# variable
input=("$@")
flag_u="false"
users=()
flag_c="false"
count=2000000
flag_t="false"
time_out=1
executable=""
i=0

# saves the received parameter and check them
for param in "${input[@]}"
  do

    #check "-t"
    if [ "${input[$i]}" = "-t" ]; then
      flag_t="true"
      #checks if have a value for this flag and after check if this a integer
      #else turn off flag_t
      if [[ "${input[$((i+1))]}" =~ ^[1-9]+$ ]]; then
        time_out="${input[$((i+1))]}"
        i=$((i+2))
      else
        flag_t="false"
        echo "You did not enter a valid value for flag -t"
      fi
      continue
    fi

    #check "-c"
    if [ "${input[$i]}" = "-c" ]; then
      flag_c="true"
      #checks if have a value for this flag and after check if this a integer
      #else turn off flag_c
      if [[ "${input[$((i+1))]}" =~ ^[1-9]+$ ]]; then
        count="${input[$((i+1))]}"
        i=$((i+2))
      else
        flag_c="false"
        echo "You did not enter a valid value for flag -c"
      fi
      continue
    fi

    #check "-u"
    if [ "${input[$i]}" = "-u" ]; then
      #checks if have a value for this flag and if this user exists
      #else turn off flag_u
      # [ -n ] check if string not ""
      if [ -n "${input[$((i+1))]}" ]; then
        # check in list of users if this user exists and save value in var u
        u=$(cut -d: -f1 /etc/passwd |grep -w "${input[$((i+1))]}")
        if [ "$u" = "${input[$((i+1))]}" ]; then
          flag_u="true"
          # add user to list of users
          users+=("${input[$((i+1))]}")
          i=$((i+2))
        else
          echo "user do not exist"
        fi
      else
        flag_u="false"
        echo "You did not enter a valid value for flag -u"
      fi
      continue
    fi

    #the script can check only one executable file
    executable="$param"
    ((i+1))
  done

# This function runs the function print_ps or print_ps_user
# number of times of $count in intervals of $time_out
ping_time() {
  if [ "$flag_u" = "false" ]; then
    echo "Pinging ‘$executable’ for any user"
    for ((i=0; i<count; i++)); do
      print_ps
      sleep "$time_out"
    done
  else
    # check if length of $users >1 then check if flag c turn on
    if [ "${#users[*]}" -gt 1 ] && [ "$flag_c" = "false" ]; then
      echo "!! mandatory to use -c flag in multiple users"
    else
      # each user runs function print_ps_user
      for u in "${users[@]}"; do
        echo "Pinging ‘$executable’ for user '$u'" 
        for ((i=0; i<count; i++)); do
          print_ps_user
          sleep "$time_out"
        done
      done
    fi
  fi
}

# This function prints count of proccessess for a specific executable file
print_ps() {
  result=$(ps -uxa |awk '{print $1"\t"$11}'|grep -c "$executable")
  echo "$executable: $result instance(s)..."
}

# This function prints count of proccessess for a specific executable file for a specific user
print_ps_user() {
  result=$(ps -uxa |awk '{print $1"\t"$11}'|grep "$u"| grep -c "$executable")
  echo "$executable: $result instance(s)..."
}

# display the first function
ping_time
