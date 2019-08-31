#!/bin/bash

#Purpose - Personal Password Generator Script
#Inputs  - Length or Count
#Action  - Generate random passwords 3 different ways
#Status  - Complete

dictionary=words_alpha-5chars.txt
dictionary_max=$(wc -l $dictionary| cut -d ' ' -f 1)

#Generates a random number between one and the max + 1
function genrandom_number {
	max=$1
	echo $(shuf -i 1-$max -n 1)
}

function random_special_char {
	array=('!' '@' '#' '$' '%' '^' '&' '(' ')' '_' '-' '+')
	size=${#array[@]}
	index=$(($RANDOM % $size))
	echo ${array[$index]}
}

#Generates a random alpha numeric string WITH OUT special characters max characters long
function genrandom_alphanumeric {
	max=$1
	echo $RANDOM | sha256sum | base64 | head -c $max
}

#Generates a random alpha numeric string WITH special characters max characters long
function genrandom_alphanumeric_special {
	max=$1
	echo $RANDOM | sha256sum | base64 | head -c $max
}

function choose_word {
	max=$dictionary_max
	line1=$(shuf -i 1-$max -n 1)
	line2=$(shuf -i 1-$max -n 1)
	word1=$(sed "${line1}q;d" $dictionary)
	word1_length=${#word1}
	word1_case=$(echo $word1 | sed "s/./\U&/$(genrandom_number $word1_length)" | sed "s/./&$(random_special_char)/$(genrandom_number $word1_length)")
	word2=$(sed "${line2}q;d" $dictionary)
	word2_length=${#word2}
	word2_case=$(echo $word2 | sed "s/./\U&/$(genrandom_number $word2_length)" | sed "s/./&$(random_special_char)/$(genrandom_number $word2_length)")
	echo $word1_case$(genrandom_number 100)$word2_case
}

function do_help {
        echo "Help Menu"
        echo -e "\n\033[0;33m./password-generator.sh -asw\e[0m\n"
        echo "Usage:"
        echo "  Primary Options:"
        echo "  -h: This Help Menu"
        echo -e "  -a <length>: Length is the length of the randomly generated alphanumeric password. \n      if there is no number after -r it defaults to 20."
        echo -e "  -s <length>: Length is the length of the randomly generated alphanumeric password \n      with special characters randomly inserted. \n      if there is no number after -r it defaults to 20."
        echo -e "  -w <count>: Count is the amount of the randomly generated passwords to output. \n"
}

function do_options {
case $secondary in
	-c )
		count=$1
		i=0
		if [ -z "$count" ]
			then
				echo -e "\nPassword: $(choose_word) \n"
			else
				echo ""
				while [ $i -le $(( $count - 1)) ]
				do
					choose_word
					i=$(( $i+1 ))
				done
				echo ""
		fi
esac
}

primary=$1; shift
case $primary in
	-h )
		do_help
		exit 0
		;;

	#Generate random alphanumeric
	-a )
		password_length=$1; shift
		secondary=$1; shift
		count=$1

		case $secondary in
			-c )
				if [ -z "$count" ]
					then
						count=10
				fi

				i=0
				if [ -z "$password_length" ]
					then
						echo ""
						while [ $i -le $(( $count - 1)) ]
						do
							echo $(genrandom_alphanumeric 20)
							i=$(( $i+1 ))
						done
						echo ""
					else
						echo ""
						while [ $i -le $(( $count - 1)) ]
						do
							echo $(genrandom_alphanumeric $password_length)
							i=$(( $i+1 ))
						done
						echo ""
				fi
				;;
			* )
				if [ -z "$password_length" ]
					then
						password=$(genrandom_alphanumeric 20)
						echo -e "\nPassword: $password \n"
					else
						password=$(genrandom_alphanumeric $password_length)
						echo -e "\nPassword: $password \n"
				fi
				;;
		esac
		;;
	#Generate random alphanumeric with special character randomly inserted
	-s )
		password_length=$1
		if [ -z "$password_length" ]
			then
				password=$((genrandom_alphanumeric_special 20) | sed "s/./&$(random_special_char)/$(genrandom_number 20)" | sed "s/./&$(random_special_char)/$(genrandom_number 20)")
				echo -e "\nPassword: $password \n"
			else
				password=$((genrandom_alphanumeric_special $password_length) | sed "s/./&$(random_special_char)/$(genrandom_number $password_length)" | sed "s/./&$(random_special_char)/$(genrandom_number $password_length)")
				echo -e "\nPassword: $password \n"

		fi
		;;

	#Generate "mixed case word w/ special chars" + number + "mixed case word w/ special chars"
	#Example: araeotIc(l5folioliferou^s
	-w )
		count=$1
		i=0
		if [ -z "$count" ]
			then
				echo -e "\nPassword: $(choose_word) \n"
			else
				echo ""
				while [ $i -le $(( $count - 1)) ]
				do
					choose_word
					i=$(( $i+1 ))
				done
				echo ""
		fi
		;;

	* )
		echo -e "\nPassword:" $(genrandom_alphanumeric 20)
		echo -e "\n\033[0;33m./password-generator.sh -h: For Help Menu\e[0m"
		exit 1
		;;
esac
