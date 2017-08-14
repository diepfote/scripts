Black        0;30     Dark Gray     1;30
Red          0;31     Light Red     1;31
Green        0;32     Light Green   1;32
Brown/Orange 0;33     Yellow        1;33
Blue         0;34     Light Blue    1;34
Purple       0;35     Light Purple  1;35
Cyan         0;36     Light Cyan    1;36
Light Gray   0;37     White         1;37
And then use them like this in your script:

#    .---------- constant part!
#    vvvv vvvv-- the code from above
RED='\033[0;31m'
NC='\033[0m' # No Color
printf "I ${RED}love${NC} Stack Overflow\n"
which prints love in red.

From @james-lim's comment, if you are using the echo command, be sure to use the -e flag to allow backslash escapes.

# Continued from above example
echo -e "I ${RED}love${NC} Stack Overflow"


# LIGHTISH RED
"I \033[1;31mlove\033[0m Stack Overflow\n"
