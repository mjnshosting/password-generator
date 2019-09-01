#!/bin/bash

#Purpose - Personal Password Generator Script
#Inputs  - Length or Count
#Action  - Generate random passwords 3 different ways
#Status  - Complete

dictionary=words_alpha-5chars.txt

if [ -e $dictionary ]
	then
		dictionary_max=$(wc -l $dictionary| cut -d ' ' -f 1)
fi

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
	head /dev/urandom | tr -dc A-Za-z0-9 | head -c $max
}

#Generates a random alpha numeric string WITH special characters max characters long
function genrandom_alphanumeric_special {
	max=$1
	head /dev/urandom | tr -dc A-Za-z0-9 | head -c $max
}

function choose_word {
	if [ -e  $dictionary ]
		then
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
		else
			echo -e "\nDictionary file does not exist.\nIs it in the current directory?\nIs the name of the dictionary file $dictionary?\n"
	fi
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
        echo -e "  Secondary Options:"
	echo -e "  * Valid for -a and -s options. This is not necessary for the -w option *"
	echo -e "  -c <count>: Count is the amount of the randomly generated passwords to output. \n"

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
						while [ $i -le $(( $count - 1)) ]
						do
							echo $(genrandom_alphanumeric 20)
							i=$(( $i+1 ))
						done
					else
						while [ $i -le $(( $count - 1)) ]
						do
							echo $(genrandom_alphanumeric $password_length)
							i=$(( $i+1 ))
						done
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
                                                while [ $i -le $(( $count - 1)) ]
                                                do
                                                        echo $((genrandom_alphanumeric_special 20) | sed "s/./&$(random_special_char)/$(genrandom_number 20)" | sed "s/./&$(random_special_char)/$(genrandom_number 20)")
                                                        i=$(( $i+1 ))
                                                done
                                        else
                                                while [ $i -le $(( $count - 1)) ]
                                                do
                                                        echo $((genrandom_alphanumeric_special $password_length) | sed "s/./&$(random_special_char)/$(genrandom_number $password_length)" | sed "s/./&$(random_special_char)/$(genrandom_number $password_length)")
                                                        i=$(( $i+1 ))
                                                done
                                fi
                                ;;
                        * )
                                if [ -z "$password_length" ]
                                        then
						password=$((genrandom_alphanumeric_special 20) | sed "s/./&$(random_special_char)/$(genrandom_number 20)" | sed "s/./&$(random_special_char)/$(genrandom_number 20)")
                                                echo -e "\nPassword: $password \n"
                                        else
						password=$((genrandom_alphanumeric_special $password_length) | sed "s/./&$(random_special_char)/$(genrandom_number $password_length)" | sed "s/./&$(random_special_char)/$(genrandom_number $password_length)")
                                                echo -e "\nPassword: $password \n"
                                fi
                                ;;
                esac
                ;;

	#Generate an even more complex random alphanumeric with special character randomly inserted
	#This option is way better than my implementation but it some password fields do not allow
	#special chars as the first field. ** Some special chars have been removed from the command.
	#Source: https://unix.stackexchange.com/a/230676
	-c )
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
                                                while [ $i -le $(( $count - 1)) ]
                                                do
							head /dev/urandom | tr -dc 'A-Za-z0-9!"#$%&()+,-.:;<>@^_' | head -c 20  ; echo
                                                        i=$(( $i+1 ))
                                                done
                                        else
                                                while [ $i -le $(( $count - 1)) ]
                                                do
							head /dev/urandom | tr -dc 'A-Za-z0-9!"#$%&()+,-.:;<>@^_' | head -c $password_length  ; echo
                                                        i=$(( $i+1 ))
                                                done
                                fi
                                ;;
                        * )
                                if [ -z "$password_length" ]
                                        then
						password=$((genrandom_alphanumeric_special 20) | sed "s/./&$(random_special_char)/$(genrandom_number 20)" | sed "s/./&$(random_special_char)/$(genrandom_number 20)")
                                                echo -e "\nPassword: $password \n"
                                        else
						password=$((genrandom_alphanumeric_special $password_length) | sed "s/./&$(random_special_char)/$(genrandom_number $password_length)" | sed "s/./&$(random_special_char)/$(genrandom_number $password_length)")
                                                echo -e "\nPassword: $password \n"
                                fi
                                ;;
                esac
                ;;

	#Generate "mixed case word w/ special chars" + number + "mixed case word w/ special chars"
	#Example: araeotIc(l5folioliferou^s
	-w )
		if [ -e $dictionary ]
			then
				count=$1
			else
				count=1
		fi

		i=0
		if [ -z "$count" ]
			then
				if [ -e $dictionary ]
					then
						echo -e "\nPassword: $(choose_word) \n"
					else
						echo -e "\nDictionary file does not exist.\nIs it in the current directory?\nIs the name of the dictionary file $dictionary?\n"
				fi
			else
				while [ $i -le $(( $count - 1)) ]
				do
					choose_word
					i=$(( $i+1 ))
				done
		fi
		;;

	* )
		echo -e "\nPassword:" $(genrandom_alphanumeric 20)
		echo -e "\n\033[0;33m./password-generator.sh -h: For Help Menu\e[0m"
		exit 1
		;;
esac
