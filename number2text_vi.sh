#!/bin/bash
# While, for, sed, awk, printf, function, cat, read, cut
# Setup variable
red='\033[1;31m'
green='\033[1;32m'
yellow='\033[1;33m'
light_cyan='\033[1;96m'
reset='\033[0m'
number='^[0-9]+$'

list_one=$(cat << EOF
0 không
1 một
2 hai
3 ba
4 bốn
5 năm
6 sáu
7 bảy
8 tám
9 chín
EOF
)

leng_num=$(cat << EOF
2 mươi
3 trăm
4 nghìn,
5 mươi
6 trăm
7 triệu,
8 mươi
9 trăm
10 tỷ,
11 mươi
12 trăm
13 nghìn tỷ,
14 mươi
15 trăm
16 triệu tỷ,
EOF
)

# Setup function
function pause_exit () {
	printf "${reset}\nPress Enter to Exit! "
	read
}

# mains
printf "\n${yellow}Nhập số: ${green}"
read user_input

if [[ $user_input == "" ]] || [ -z $user_input ]; then
	printf "${red}\nKhông được để trống!${reset}"
	pause_exit
	exit 0
else
	if ! [[ $user_input =~ $number ]]; then
		printf "${red}\nChỉ nhập số!${reset}"
		pause_exit
		exit 0
	fi
fi

answer=""
length_inp=${#user_input}

if [[ $length_inp -gt $(printf "${leng_num##*$'\n'}" | awk '{print $1}') ]]; then
	printf "${red}\nSố quá lớn! Tối đa độ dài $(printf "${leng_num##*$'\n'}" | awk '{print $1}') số"
	pause_exit
else
	for i in $(seq 1 ${#user_input}); do
		while IFS= read -r ia; do
			if [[ "$(printf $ia | awk '{print $1}')" == "$(printf "$user_input" | cut -c $i)" ]]; then
				answer+="$(printf "$ia" | awk '{for(i=2;i<=NF;i++) printf $i" "; print ""}') "
			fi
		done < <(printf '%s\n' "$list_one")
		while IFS= read -r ia; do
			if [[ "$(printf $ia | awk '{print $1}')" == "$length_inp" ]]; then
				answer+="$(printf "$ia" | awk '{for(i=2;i<=NF;i++) printf $i" "; print ""}') "
			fi
		done < <(printf '%s\n' "$leng_num")
		length_inp=$((length_inp - 1))
	done
	answer="$(printf "$answer" | awk '{ print toupper(substr($0, 1, 1)) substr($0, 2) }' | sed 's/  / /g' | sed 's/một mươi/mười/g' | sed 's/mười không/mười/g' | sed 's/mươi không/mươi/g' | sed 's/không mươi/linh/g' | sed 's/mươi một/mươi mốt/g')"
	answer="${answer:0:-1}."
	printf "Kết quả: ${light_cyan}$answer${reset}\n\n"
fi
exit 0
