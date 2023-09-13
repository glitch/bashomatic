#!/usr/bin/env bash

# stackoverflow.com/a/246128
SOURCE=${BASH_SOURCE[0]}
while [ -L "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )
  SOURCE=$(readlink "$SOURCE")
  [[ $SOURCE != /* ]] && SOURCE=$DIR/$SOURCE # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
MY_DIR=$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )

#and then....
BASE_DIR=$(realpath "${MY_DIR}/..") # customize to your scripting dir structure.

echo "Done with MY_DIR stuff: ${MY_DIR}" 

usage() {
  echo -e "stuff, the -e honors escaped stuff like \tfor tab"
  echo -e "For your getopt stuff.."
  echo -e "\t-a | --a-flag : Set a-flag, no pun intended"
  echo -e "\t-b | --b-flag : Set b-flag"
  echo -e "\t-c <value> | --c-arg-with-value <value> : set a value for c"
  echo -e "\t-d <value> | --d-array-val <value> : Can repeat multiple times and will append to underlying array"
  echo -e ""
  echo -e "Examples"
  echo -e "${SOURCE} -a --b-flag -c foo -d dude -d bro -d sir -d please --d-array-val stopthismadness"
  exit 1
}

# How to use "getopt" which is different that getopts plural
MY_ARGS=$(getopt -o "abc:d:h" -l "help,a-flag,b-flag c-arg-with-value:,d-array-val:" -- "$@")

# Then, make sure it works
if [[ $? -ne 0 ]]; then
  echo "dude, getopt not working!"
  exit 1;
fi

# Make sure you have defaults for things
ARG_A=""
ARG_B=""
ARG_C=""
declare -a ARG_D_ARRAY=()

#Now eval & pull the pieces
eval set -- "$MY_ARGS"
while [ : ]; do
  case "$1" in
    -h | --help)
      usage; #call your usage function
      exit 1;
      ;;
      
    -a | --a-flag)
      echo "Found the \"a\" flag"
      ARG_A="true or something"
      shift 1
      ;;
    
    -b | --b-flag)
      echo "Found the \"b\" flag"
      ARG_B="true or something"
      shift 1
      ;;
      
    -c | --c-arg-with-value)
      echo "Parse out c-arg-with-value and value ${2}"
      ARG_C=$2
      shift 2 #we have 2 pieces right?
      ;;
    
    -d | --d-array-val)
      echo "Here we parse d value and add it to an array"
      ARG_D_ARRAY+=($2)
      shift 2
      ;;
      
    --)
      shift
      #This is how you pick up the end
      break
      ;;
  esac
done

# test for empty vars and stuff
if [[ ! -z "${ARG_A}" ]] || [[ ! -z "${ARG_B}" ]]; then
  echo "looks like you had something for arg_a OR arg_b"
fi

# test the array
if [[ ! -z "${ARG_D_ARRAY[@]}" ]]; then
  echo "Let's process ARG_D_ARRAY..."
  for d in ${ARG_D_ARRAY[@]}; do
    echo "item d in the ARG_D_ARRAY is ${d}";
    # you could run an arbitrary command etc.
  done
fi

echo "So long and thanks for all the fish!"
