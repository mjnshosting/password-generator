# MJNS Password Generator
Generate Passwords for user accounts
 
## Purpose
I needed a customized password generator that does random characters and word based password with a mix of numbers and special characters.
 
#### Original Word List: [dwyl/english-words - Word List ](https://github.com/dwyl/english-words)
* The included dictionary excludes words that have less than 5 characters
#### Inspiraton: [untroubled.org - Secure Passphrase Generator](https://untroubled.org/pwgen/ppgen.cgi) 

## Help
```
Help Menu
./password-generator.sh -asw
Usage:
  Primary Options:
  -h: This Help Menu
  -a <length>: Length is the length of the randomly generated alphanumeric password.
      if there is no number after -r it defaults to 20.
  -s <length>: Length is the length of the randomly generated alphanumeric password
      with special characters randomly inserted.
      if there is no number after -r it defaults to 20.
  -w <count>: Count is the amount of the randomly generated passwords to output.
  ```

## Examples
```
./password-generator.sh -a
Password: N2M3NTNkNjY1MGRkYzQw

./password-generator.sh -a 40
Password: N2YwNzVmYjk0YTZiNzc3YzU5OWJhMzMzYTA5MDUy

./password-generator.sh -s
Password: YTRjYjU4)N#WU4OTIxOGQy

./password-generator.sh -s 40
Password: ZTYwYTMwYTU3MzNl_NGZjOWRlYzczOODI3M2Q4YWJj

./password-generator.sh -w
Password: Upd!ome58de%famY

./password-generator.sh -w 5
pseudOcorte_x54sticklEba#ck
Ka)bab65solerrT
unhyPocritica#l27refAce%d
unsi^gHing45underLe(t
ter)gaL89t)aHiti
```

## Issues
### Problem - Receive output that shows number then one word when using -w
#### number + word ... BAD
```
39illinitiO%n
```
#### word + number + word ... GOOD
```
whiteehAwse74brInkmansh#ip
```
#### Solution - This issue comes from DOS newline characters in the dictionary
```
apt install dos2unix
dos2unix words_alpha-5chars.txt
```
