#!/bin/bash
# for, sed, awk, printf, echo, read, cut


### How to use?
# run [bash number2text_vi.sh] and input your number
# or run with arg number [bash number2text_vi.sh 12345]
### You can make it executable on your Linux

# Setup variable
red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
light_cyan='\033[1;96m'
reset='\033[0m'
number='^[0-9]+$'
max_number=18

if [[ $# -gt 1 ]] 2> /dev/null; then
	printf "${red}\nToo many arguments!\n\n${reset}"
	exit 0
fi

declare -A list_one
declare -A leng_num

list_one=([0]="không" [1]="một" [2]="hai" [3]="ba" [4]="bốn" [5]="năm" [6]="sáu" [7]="bảy" [8]="tám" [9]="chín")
leng_num=([2]="mươi" [3]="trăm" [4]="nghìn" [5]="mươi" [6]="trăm" [7]="triệu" [8]="mươi" [9]="trăm" [10]="tỷ" [11]="mươi" [12]="trăm" [13]="nghìn tỷ" [14]="mươi" [15]="trăm" [16]="triệu tỷ" [17]="mươi" [18]="trăm")

# mains
if [[ $@ == "" ]]; then
	printf "\n${yellow}Nhập số: ${green}"
	read user_input
else
	user_input="$@"
fi

if [[ $user_input == "" ]] || [ -z $user_input ]; then
	printf "${red}\nKhông được để trống!\n\n${reset}"
	exit 0
else
	if ! [[ $user_input =~ $number ]]; then
		printf "${red}\nChỉ nhập số!\n\n${reset}"
		exit 0
	fi
fi

answer=""
length_inp=${#user_input}

if [[ $length_inp -gt $max_number ]]; then
	printf "${red}\nSố quá lớn! Tối đa độ dài ${max_number} số\n\n"
else
	for i in $(seq 1 ${#user_input}); do
		num=$(printf "$user_input" | cut -c $i)
		answer+="$(printf "${list_one[$num]}") "
		answer+="$(printf "${leng_num[$length_inp]}") "
		length_inp=$((length_inp - 1))
	done
	answer="${answer:0:-2}."
	answer="$(printf "$answer" | sed 's/  / /g' | sed 's/một mươi/mười/g' | sed 's/mười không/mười/g' | sed 's/mươi không/mươi/g' | sed 's/không mươi/linh/g' | sed 's/mươi một/mươi mốt/g' | sed 's/\< linh.\>/./' | sed 's/ không trăm././' | sed 's/\<linh nghìn\>/nghìn/g' | sed 's/.linh././g' | sed 's/^.nghìn//' | sed 's/ không trăm././' | sed "s/triệu.nghìn./triệu./" | sed "s/trăm.triệu./trăm triệu./" | sed "s/tỷ.triệu.không trăm./tỷ./" | sed "s/trăm.tỷ./trăm tỷ./" | sed "s/tỷ.tỷ.nghìn không trăm./tỷ./" | awk '{ print toupper(substr($0, 1, 1)) substr($0, 2) }')"
	if [[ $@ == "" ]]; then
		printf "Kết quả: ${light_cyan}$answer${reset}\n\n"
	else
		echo "$answer"
	fi
fi
exit 0
