#!/usr/bin/env bash

## @author:       Johan Alexis | mind2hex
## @github:       https://github.com/mind2hex

## Project Name:  nse-search.sh
## Description:   bash script to monitor the processes that are activated in a certain period of time

## @style:        https://github.com/fryntiz/bash-guide-style

## @licence:      https://www.gnu.org/licences/gpl.txt
##
## This program is free software: you can redistribute it and/or modify
## it under the terms of the GNU General Public License as published by
## the Free Software Foundation, either version 3 of the License, or
## (at your option) any later version.
##
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>

#############################
##     CONSTANTS           ##
#############################  

VERSION="[v1.00]"
AUTHOR="mind2hex"


NSE_SCRIPTS_DB="/usr/share/nmap/scripts/script.db"
NSE_SCRIPTS='/usr/share/nmap/scripts/' #directory
NSE_SERVICES='/usr/share/nmap/nmap-services' #file
NSE_PROTOCOLS='/usr/share/nmap/nmap-protocols' #file
NSE_MAC='/usr/share/nmap/nmap-mac-prefixes' #file

#############################
##    BASIC FUNCTIONS      ##
#############################  

banner(){
    echo "
G1swOzMxbRtbMzg7Mjs1Nzs3MjsyNTRtG1szOW0bWzM4OzI7NTM7NzY7MjU0bRtbMzltChtbMzg7
Mjs0Njs4MzsyNTNtIBtbMzltG1szODsyOzQzOzg3OzI1Mm1fG1szOW0bWzM4OzI7NDA7OTE7MjUx
bSAbWzM5bRtbMzg7MjszNzs5NTsyNTBtIBtbMzltG1szODsyOzM0OzEwMDsyNDltIBtbMzltG1sz
ODsyOzMxOzEwNDsyNDdtIBtbMzltG1szODsyOzI5OzEwODsyNDZtIBtbMzltG1szODsyOzI2OzEx
MjsyNDRtIBtbMzltG1szODsyOzI0OzExNjsyNDNtIBtbMzltG1szODsyOzIxOzEyMDsyNDFtXxtb
MzltG1szODsyOzE5OzEyNTsyMzltXxtbMzltG1szODsyOzE3OzEyOTsyMzdtXxtbMzltG1szODsy
OzE1OzEzMzsyMzVtXxtbMzltG1szODsyOzEzOzEzNzsyMzJtXxtbMzltG1szODsyOzExOzE0Mjsy
MzBtXxtbMzltG1szODsyOzEwOzE0NjsyMjdtXxtbMzltG1szODsyOzg7MTUwOzIyNG0gG1szOW0b
WzM4OzI7NzsxNTQ7MjIybV8bWzM5bRtbMzg7Mjs1OzE1ODsyMTltXxtbMzltG1szODsyOzQ7MTYy
OzIxNm1fG1szOW0bWzM4OzI7MzsxNjY7MjEzbV8bWzM5bRtbMzg7MjszOzE3MDsyMTBtXxtbMzlt
G1szODsyOzI7MTc0OzIwNm1fG1szOW0bWzM4OzI7MTsxNzg7MjAzbV8bWzM5bRtbMzg7MjsxOzE4
MjsxOTltIBtbMzltG1szODsyOzE7MTg2OzE5Nm0gG1szOW0bWzM4OzI7MTsxOTA7MTkybSAbWzM5
bRtbMzg7MjsxOzE5MzsxODltIBtbMzltG1szODsyOzE7MTk3OzE4NW1fG1szOW0bWzM4OzI7MTsy
MDA7MTgxbV8bWzM5bRtbMzg7MjsxOzIwNDsxNzdtXxtbMzltG1szODsyOzI7MjA3OzE3M21fG1sz
OW0bWzM4OzI7MzsyMTA7MTY5bV8bWzM5bRtbMzg7Mjs0OzIxNDsxNjVtXxtbMzltG1szODsyOzU7
MjE3OzE2MW1fG1szOW0bWzM4OzI7NjsyMjA7MTU3bSAbWzM5bRtbMzg7Mjs3OzIyMjsxNTNtXxtb
MzltG1szODsyOzg7MjI1OzE0OW1fG1szOW0bWzM4OzI7MTA7MjI4OzE0NW1fG1szOW0bWzM4OzI7
MTI7MjMwOzE0MG1fG1szOW0bWzM4OzI7MTM7MjMzOzEzNm1fG1szOW0bWzM4OzI7MTU7MjM1OzEz
Mm1fG1szOW0bWzM4OzI7MTc7MjM3OzEyOG1fG1szOW0bWzM4OzI7MjA7MjM5OzEyNG0gG1szOW0b
WzM4OzI7MjI7MjQxOzExOW1fG1szOW0bWzM4OzI7MjQ7MjQzOzExNW1fG1szOW0bWzM4OzI7Mjc7
MjQ1OzExMW1fG1szOW0bWzM4OzI7Mjk7MjQ2OzEwN21fG1szOW0bWzM4OzI7MzI7MjQ4OzEwM21f
G1szOW0bWzM4OzI7MzU7MjQ5Ozk4bV8bWzM5bRtbMzg7MjszODsyNTA7OTRtXxtbMzltG1szODsy
OzQxOzI1MTs5MG0gG1szOW0bWzM4OzI7NDQ7MjUyOzg2bV8bWzM5bRtbMzg7Mjs0NzsyNTM7ODJt
XxtbMzltG1szODsyOzUxOzI1Mzs3OG1fG1szOW0bWzM4OzI7NTQ7MjU0Ozc0bV8bWzM5bRtbMzg7
Mjs1ODsyNTQ7NzFtXxtbMzltG1szODsyOzYxOzI1NDs2N21fG1szOW0bWzM4OzI7NjU7MjU0OzYz
bV8bWzM5bRtbMzg7Mjs2OTsyNTQ7NjBtIBtbMzltG1szODsyOzcyOzI1NDs1Nm1fG1szOW0bWzM4
OzI7NzY7MjU0OzUzbV8bWzM5bRtbMzg7Mjs4MDsyNTM7NDltXxtbMzltG1szODsyOzg0OzI1Mzs0
Nm1fG1szOW0bWzM4OzI7ODg7MjUyOzQzbV8bWzM5bRtbMzg7Mjs5MjsyNTE7NDBtXxtbMzltG1sz
ODsyOzk2OzI1MDszN21fG1szOW0bWzM4OzI7MTAwOzI0OTszNG0gG1szOW0bWzM4OzI7MTA0OzI0
NzszMW0gG1szOW0bWzM4OzI7MTA5OzI0NjsyOG0gG1szOW0bWzM4OzI7MTEzOzI0NDsyNm0gG1sz
OW0bWzM4OzI7MTE3OzI0MjsyM20gG1szOW0bWzM4OzI7MTIxOzI0MDsyMW0gG1szOW0bWzM4OzI7
MTI1OzIzOTsxOW0gG1szOW0bWzM4OzI7MTMwOzIzNjsxNm0gG1szOW0bWzM4OzI7MTM0OzIzNDsx
NG0gG1szOW0bWzM4OzI7MTM4OzIzMjsxM20bWzM5bQobWzM4OzI7Mzc7OTU7MjUwbSgbWzM5bRtb
Mzg7MjszNDsxMDA7MjQ5bSAbWzM5bRtbMzg7MjszMTsxMDQ7MjQ3bSgbWzM5bRtbMzg7MjsyOTsx
MDg7MjQ2bSAbWzM5bRtbMzg7MjsyNjsxMTI7MjQ0bSAbWzM5bRtbMzg7MjsyNDsxMTY7MjQzbSAb
WzM5bRtbMzg7MjsyMTsxMjA7MjQxbSAbWzM5bRtbMzg7MjsxOTsxMjU7MjM5bS8bWzM5bRtbMzg7
MjsxNzsxMjk7MjM3bSgbWzM5bRtbMzg7MjsxNTsxMzM7MjM1bSAbWzM5bRtbMzg7MjsxMzsxMzc7
MjMybSAbWzM5bRtbMzg7MjsxMTsxNDI7MjMwbV8bWzM5bRtbMzg7MjsxMDsxNDY7MjI3bV8bWzM5
bRtbMzg7Mjs4OzE1MDsyMjRtXxtbMzltG1szODsyOzc7MTU0OzIyMm1fG1szOW0bWzM4OzI7NTsx
NTg7MjE5bSAbWzM5bRtbMzg7Mjs0OzE2MjsyMTZtKBtbMzltG1szODsyOzM7MTY2OzIxM20gG1sz
OW0bWzM4OzI7MzsxNzA7MjEwbSAbWzM5bRtbMzg7MjsyOzE3NDsyMDZtXxtbMzltG1szODsyOzE7
MTc4OzIwM21fG1szOW0bWzM4OzI7MTsxODI7MTk5bV8bWzM5bRtbMzg7MjsxOzE4NjsxOTZtXxtb
MzltG1szODsyOzE7MTkwOzE5Mm0gG1szOW0bWzM4OzI7MTsxOTM7MTg5bVwbWzM5bRtbMzg7Mjsx
OzE5NzsxODVtIBtbMzltG1szODsyOzE7MjAwOzE4MW0gG1szOW0bWzM4OzI7MTsyMDQ7MTc3bSgb
WzM5bRtbMzg7MjsyOzIwNzsxNzNtIBtbMzltG1szODsyOzM7MjEwOzE2OW0gG1szOW0bWzM4OzI7
NDsyMTQ7MTY1bV8bWzM5bRtbMzg7Mjs1OzIxNzsxNjFtXxtbMzltG1szODsyOzY7MjIwOzE1N21f
G1szOW0bWzM4OzI7NzsyMjI7MTUzbV8bWzM5bRtbMzg7Mjs4OzIyNTsxNDltIBtbMzltG1szODsy
OzEwOzIyODsxNDVtKBtbMzltG1szODsyOzEyOzIzMDsxNDBtIBtbMzltG1szODsyOzEzOzIzMzsx
MzZtIBtbMzltG1szODsyOzE1OzIzNTsxMzJtXxtbMzltG1szODsyOzE3OzIzNzsxMjhtXxtbMzlt
G1szODsyOzIwOzIzOTsxMjRtXxtbMzltG1szODsyOzIyOzI0MTsxMTltXxtbMzltG1szODsyOzI0
OzI0MzsxMTVtIBtbMzltG1szODsyOzI3OzI0NTsxMTFtKBtbMzltG1szODsyOzI5OzI0NjsxMDdt
IBtbMzltG1szODsyOzMyOzI0ODsxMDNtIBtbMzltG1szODsyOzM1OzI0OTs5OG1fG1szOW0bWzM4
OzI7Mzg7MjUwOzk0bV8bWzM5bRtbMzg7Mjs0MTsyNTE7OTBtXxtbMzltG1szODsyOzQ0OzI1Mjs4
Nm0gG1szOW0bWzM4OzI7NDc7MjUzOzgybSAbWzM5bRtbMzg7Mjs1MTsyNTM7NzhtKBtbMzltG1sz
ODsyOzU0OzI1NDs3NG0gG1szOW0bWzM4OzI7NTg7MjU0OzcxbSAbWzM5bRtbMzg7Mjs2MTsyNTQ7
NjdtXxtbMzltG1szODsyOzY1OzI1NDs2M21fG1szOW0bWzM4OzI7Njk7MjU0OzYwbV8bWzM5bRtb
Mzg7Mjs3MjsyNTQ7NTZtXxtbMzltG1szODsyOzc2OzI1NDs1M20gG1szOW0bWzM4OzI7ODA7MjUz
OzQ5bSgbWzM5bRtbMzg7Mjs4NDsyNTM7NDZtIBtbMzltG1szODsyOzg4OzI1Mjs0M20gG1szOW0b
WzM4OzI7OTI7MjUxOzQwbV8bWzM5bRtbMzg7Mjs5NjsyNTA7MzdtXxtbMzltG1szODsyOzEwMDsy
NDk7MzRtXxtbMzltG1szODsyOzEwNDsyNDc7MzFtXxtbMzltG1szODsyOzEwOTsyNDY7MjhtIBtb
MzltG1szODsyOzExMzsyNDQ7MjZtfBtbMzltG1szODsyOzExNzsyNDI7MjNtXBtbMzltG1szODsy
OzEyMTsyNDA7MjFtIBtbMzltG1szODsyOzEyNTsyMzk7MTltIBtbMzltG1szODsyOzEzMDsyMzY7
MTZtIBtbMzltG1szODsyOzEzNDsyMzQ7MTRtIBtbMzltG1szODsyOzEzODsyMzI7MTNtIBtbMzlt
G1szODsyOzE0MjsyMjk7MTFtLxtbMzltG1szODsyOzE0NzsyMjc7OW18G1szOW0bWzM4OzI7MTUx
OzIyNDs4bRtbMzltChtbMzg7MjsyOTsxMDg7MjQ2bXwbWzM5bRtbMzg7MjsyNjsxMTI7MjQ0bSAb
WzM5bRtbMzg7MjsyNDsxMTY7MjQzbSAbWzM5bRtbMzg7MjsyMTsxMjA7MjQxbVwbWzM5bRtbMzg7
MjsxOTsxMjU7MjM5bSAbWzM5bRtbMzg7MjsxNzsxMjk7MjM3bSAbWzM5bRtbMzg7MjsxNTsxMzM7
MjM1bSgbWzM5bRtbMzg7MjsxMzsxMzc7MjMybSAbWzM5bRtbMzg7MjsxMTsxNDI7MjMwbXwbWzM5
bRtbMzg7MjsxMDsxNDY7MjI3bSAbWzM5bRtbMzg7Mjs4OzE1MDsyMjRtKBtbMzltG1szODsyOzc7
MTU0OzIyMm0gG1szOW0bWzM4OzI7NTsxNTg7MjE5bSAbWzM5bRtbMzg7Mjs0OzE2MjsyMTZtIBtb
MzltG1szODsyOzM7MTY2OzIxM20gG1szOW0bWzM4OzI7MzsxNzA7MjEwbVwbWzM5bRtbMzg7Mjsy
OzE3NDsyMDZtfBtbMzltG1szODsyOzE7MTc4OzIwM20gG1szOW0bWzM4OzI7MTsxODI7MTk5bSgb
WzM5bRtbMzg7MjsxOzE4NjsxOTZtIBtbMzltG1szODsyOzE7MTkwOzE5Mm0gG1szOW0bWzM4OzI7
MTsxOTM7MTg5bSAbWzM5bRtbMzg7MjsxOzE5NzsxODVtIBtbMzltG1szODsyOzE7MjAwOzE4MW1c
G1szOW0bWzM4OzI7MTsyMDQ7MTc3bS8bWzM5bRtbMzg7MjsyOzIwNzsxNzNtIBtbMzltG1szODsy
OzM7MjEwOzE2OW0gG1szOW0bWzM4OzI7NDsyMTQ7MTY1bXwbWzM5bRtbMzg7Mjs1OzIxNzsxNjFt
IBtbMzltG1szODsyOzY7MjIwOzE1N20oG1szOW0bWzM4OzI7NzsyMjI7MTUzbSAbWzM5bRtbMzg7
Mjs4OzIyNTsxNDltIBtbMzltG1szODsyOzEwOzIyODsxNDVtIBtbMzltG1szODsyOzEyOzIzMDsx
NDBtIBtbMzltG1szODsyOzEzOzIzMzsxMzZtXBtbMzltG1szODsyOzE1OzIzNTsxMzJtfBtbMzlt
G1szODsyOzE3OzIzNzsxMjhtIBtbMzltG1szODsyOzIwOzIzOTsxMjRtKBtbMzltG1szODsyOzIy
OzI0MTsxMTltIBtbMzltG1szODsyOzI0OzI0MzsxMTVtIBtbMzltG1szODsyOzI3OzI0NTsxMTFt
IBtbMzltG1szODsyOzI5OzI0NjsxMDdtIBtbMzltG1szODsyOzMyOzI0ODsxMDNtXBtbMzltG1sz
ODsyOzM1OzI0OTs5OG18G1szOW0bWzM4OzI7Mzg7MjUwOzk0bSAbWzM5bRtbMzg7Mjs0MTsyNTE7
OTBtKBtbMzltG1szODsyOzQ0OzI1Mjs4Nm0gG1szOW0bWzM4OzI7NDc7MjUzOzgybSAbWzM5bRtb
Mzg7Mjs1MTsyNTM7NzhtIBtbMzltG1szODsyOzU0OzI1NDs3NG0pG1szOW0bWzM4OzI7NTg7MjU0
OzcxbSAbWzM5bRtbMzg7Mjs2MTsyNTQ7NjdtfBtbMzltG1szODsyOzY1OzI1NDs2M20gG1szOW0b
WzM4OzI7Njk7MjU0OzYwbSgbWzM5bRtbMzg7Mjs3MjsyNTQ7NTZtIBtbMzltG1szODsyOzc2OzI1
NDs1M20gG1szOW0bWzM4OzI7ODA7MjUzOzQ5bSAbWzM5bRtbMzg7Mjs4NDsyNTM7NDZtIBtbMzlt
G1szODsyOzg4OzI1Mjs0M20pG1szOW0bWzM4OzI7OTI7MjUxOzQwbXwbWzM5bRtbMzg7Mjs5Njsy
NTA7MzdtIBtbMzltG1szODsyOzEwMDsyNDk7MzRtKBtbMzltG1szODsyOzEwNDsyNDc7MzFtIBtb
MzltG1szODsyOzEwOTsyNDY7MjhtIBtbMzltG1szODsyOzExMzsyNDQ7MjZtIBtbMzltG1szODsy
OzExNzsyNDI7MjNtIBtbMzltG1szODsyOzEyMTsyNDA7MjFtXBtbMzltG1szODsyOzEyNTsyMzk7
MTltfBtbMzltG1szODsyOzEzMDsyMzY7MTZtIBtbMzltG1szODsyOzEzNDsyMzQ7MTRtKRtbMzlt
G1szODsyOzEzODsyMzI7MTNtIBtbMzltG1szODsyOzE0MjsyMjk7MTFtIBtbMzltG1szODsyOzE0
NzsyMjc7OW0gG1szOW0bWzM4OzI7MTUxOzIyNDs4bSgbWzM5bRtbMzg7MjsxNTU7MjIxOzZtIBtb
MzltG1szODsyOzE1OTsyMTg7NW18G1szOW0bWzM4OzI7MTYzOzIxNTs0bRtbMzltChtbMzg7Mjsy
MTsxMjA7MjQxbXwbWzM5bRtbMzg7MjsxOTsxMjU7MjM5bSAbWzM5bRtbMzg7MjsxNzsxMjk7MjM3
bSAbWzM5bRtbMzg7MjsxNTsxMzM7MjM1bSAbWzM5bRtbMzg7MjsxMzsxMzc7MjMybVwbWzM5bRtb
Mzg7MjsxMTsxNDI7MjMwbSAbWzM5bRtbMzg7MjsxMDsxNDY7MjI3bXwbWzM5bRtbMzg7Mjs4OzE1
MDsyMjRtIBtbMzltG1szODsyOzc7MTU0OzIyMm18G1szOW0bWzM4OzI7NTsxNTg7MjE5bSAbWzM5
bRtbMzg7Mjs0OzE2MjsyMTZtKBtbMzltG1szODsyOzM7MTY2OzIxM21fG1szOW0bWzM4OzI7Mzsx
NzA7MjEwbV8bWzM5bRtbMzg7MjsyOzE3NDsyMDZtXxtbMzltG1szODsyOzE7MTc4OzIwM21fG1sz
OW0bWzM4OzI7MTsxODI7MTk5bV8bWzM5bRtbMzg7MjsxOzE4NjsxOTZtfBtbMzltG1szODsyOzE7
MTkwOzE5Mm0gG1szOW0bWzM4OzI7MTsxOTM7MTg5bSgbWzM5bRtbMzg7MjsxOzE5NzsxODVtXxtb
MzltG1szODsyOzE7MjAwOzE4MW1fG1szOW0bWzM4OzI7MTsyMDQ7MTc3bSAbWzM5bRtbMzg7Mjsy
OzIwNzsxNzNtXxtbMzltG1szODsyOzM7MjEwOzE2OW1fG1szOW0bWzM4OzI7NDsyMTQ7MTY1bV8b
WzM5bRtbMzg7Mjs1OzIxNzsxNjFtXxtbMzltG1szODsyOzY7MjIwOzE1N21fG1szOW0bWzM4OzI7
NzsyMjI7MTUzbXwbWzM5bRtbMzg7Mjs4OzIyNTsxNDltIBtbMzltG1szODsyOzEwOzIyODsxNDVt
KBtbMzltG1szODsyOzEyOzIzMDsxNDBtXxtbMzltG1szODsyOzEzOzIzMzsxMzZtXxtbMzltG1sz
ODsyOzE1OzIzNTsxMzJtXxtbMzltG1szODsyOzE3OzIzNzsxMjhtXxtbMzltG1szODsyOzIwOzIz
OTsxMjRtXxtbMzltG1szODsyOzIyOzI0MTsxMTltfBtbMzltG1szODsyOzI0OzI0MzsxMTVtIBtb
MzltG1szODsyOzI3OzI0NTsxMTFtKBtbMzltG1szODsyOzI5OzI0NjsxMDdtXxtbMzltG1szODsy
OzMyOzI0ODsxMDNtXxtbMzltG1szODsyOzM1OzI0OTs5OG0gG1szOW0bWzM4OzI7Mzg7MjUwOzk0
bSAbWzM5bRtbMzg7Mjs0MTsyNTE7OTBtIBtbMzltG1szODsyOzQ0OzI1Mjs4Nm18G1szOW0bWzM4
OzI7NDc7MjUzOzgybSAbWzM5bRtbMzg7Mjs1MTsyNTM7NzhtKBtbMzltG1szODsyOzU0OzI1NDs3
NG1fG1szOW0bWzM4OzI7NTg7MjU0OzcxbV8bWzM5bRtbMzg7Mjs2MTsyNTQ7NjdtXxtbMzltG1sz
ODsyOzY1OzI1NDs2M20pG1szOW0bWzM4OzI7Njk7MjU0OzYwbSAbWzM5bRtbMzg7Mjs3MjsyNTQ7
NTZtfBtbMzltG1szODsyOzc2OzI1NDs1M20gG1szOW0bWzM4OzI7ODA7MjUzOzQ5bSgbWzM5bRtb
Mzg7Mjs4NDsyNTM7NDZtXxtbMzltG1szODsyOzg4OzI1Mjs0M21fG1szOW0bWzM4OzI7OTI7MjUx
OzQwbV8bWzM5bRtbMzg7Mjs5NjsyNTA7MzdtXxtbMzltG1szODsyOzEwMDsyNDk7MzRtKRtbMzlt
G1szODsyOzEwNDsyNDc7MzFtfBtbMzltG1szODsyOzEwOTsyNDY7MjhtIBtbMzltG1szODsyOzEx
MzsyNDQ7MjZtfBtbMzltG1szODsyOzExNzsyNDI7MjNtIBtbMzltG1szODsyOzEyMTsyNDA7MjFt
IBtbMzltG1szODsyOzEyNTsyMzk7MTltIBtbMzltG1szODsyOzEzMDsyMzY7MTZtIBtbMzltG1sz
ODsyOzEzNDsyMzQ7MTRtIBtbMzltG1szODsyOzEzODsyMzI7MTNtfBtbMzltG1szODsyOzE0Mjsy
Mjk7MTFtIBtbMzltG1szODsyOzE0NzsyMjc7OW0oG1szOW0bWzM4OzI7MTUxOzIyNDs4bV8bWzM5
bRtbMzg7MjsxNTU7MjIxOzZtXxtbMzltG1szODsyOzE1OTsyMTg7NW1fG1szOW0bWzM4OzI7MTYz
OzIxNTs0bSkbWzM5bRtbMzg7MjsxNjc7MjEyOzNtIBtbMzltG1szODsyOzE3MTsyMDk7Mm18G1sz
OW0bWzM4OzI7MTc1OzIwNjsybRtbMzltChtbMzg7MjsxNTsxMzM7MjM1bXwbWzM5bRtbMzg7Mjsx
MzsxMzc7MjMybSAbWzM5bRtbMzg7MjsxMTsxNDI7MjMwbSgbWzM5bRtbMzg7MjsxMDsxNDY7MjI3
bVwbWzM5bRtbMzg7Mjs4OzE1MDsyMjRtIBtbMzltG1szODsyOzc7MTU0OzIyMm1cG1szOW0bWzM4
OzI7NTsxNTg7MjE5bSkbWzM5bRtbMzg7Mjs0OzE2MjsyMTZtIBtbMzltG1szODsyOzM7MTY2OzIx
M20oG1szOW0bWzM4OzI7MzsxNzA7MjEwbV8bWzM5bRtbMzg7MjsyOzE3NDsyMDZtXxtbMzltG1sz
ODsyOzE7MTc4OzIwM21fG1szOW0bWzM4OzI7MTsxODI7MTk5bV8bWzM5bRtbMzg7MjsxOzE4Njsx
OTZtXxtbMzltG1szODsyOzE7MTkwOzE5Mm0gG1szOW0bWzM4OzI7MTsxOTM7MTg5bSAbWzM5bRtb
Mzg7MjsxOzE5NzsxODVtfBtbMzltG1szODsyOzE7MjAwOzE4MW0gG1szOW0bWzM4OzI7MTsyMDQ7
MTc3bSAbWzM5bRtbMzg7MjsyOzIwNzsxNzNtXxtbMzltG1szODsyOzM7MjEwOzE2OW1fG1szOW0b
WzM4OzI7NDsyMTQ7MTY1bSgbWzM5bRtbMzg7Mjs1OzIxNzsxNjFtXxtbMzltG1szODsyOzY7MjIw
OzE1N21fG1szOW0bWzM4OzI7NzsyMjI7MTUzbV8bWzM5bRtbMzg7Mjs4OzIyNTsxNDltXxtbMzlt
G1szODsyOzEwOzIyODsxNDVtXxtbMzltG1szODsyOzEyOzIzMDsxNDBtKBtbMzltG1szODsyOzEz
OzIzMzsxMzZtXxtbMzltG1szODsyOzE1OzIzNTsxMzJtXxtbMzltG1szODsyOzE3OzIzNzsxMjht
XxtbMzltG1szODsyOzIwOzIzOTsxMjRtXxtbMzltG1szODsyOzIyOzI0MTsxMTltXxtbMzltG1sz
ODsyOzI0OzI0MzsxMTVtIBtbMzltG1szODsyOzI3OzI0NTsxMTFtIBtbMzltG1szODsyOzI5OzI0
NjsxMDdtfBtbMzltG1szODsyOzMyOzI0ODsxMDNtIBtbMzltG1szODsyOzM1OzI0OTs5OG0gG1sz
OW0bWzM4OzI7Mzg7MjUwOzk0bV8bWzM5bRtbMzg7Mjs0MTsyNTE7OTBtXxtbMzltG1szODsyOzQ0
OzI1Mjs4Nm0pG1szOW0bWzM4OzI7NDc7MjUzOzgybSAbWzM5bRtbMzg7Mjs1MTsyNTM7NzhtIBtb
MzltG1szODsyOzU0OzI1NDs3NG18G1szOW0bWzM4OzI7NTg7MjU0OzcxbSAbWzM5bRtbMzg7Mjs2
MTsyNTQ7NjdtIBtbMzltG1szODsyOzY1OzI1NDs2M21fG1szOW0bWzM4OzI7Njk7MjU0OzYwbV8b
WzM5bRtbMzg7Mjs3MjsyNTQ7NTZtXxtbMzltG1szODsyOzc2OzI1NDs1M20gG1szOW0bWzM4OzI7
ODA7MjUzOzQ5bSAbWzM5bRtbMzg7Mjs4NDsyNTM7NDZtfBtbMzltG1szODsyOzg4OzI1Mjs0M20g
G1szOW0bWzM4OzI7OTI7MjUxOzQwbSAbWzM5bRtbMzg7Mjs5NjsyNTA7MzdtIBtbMzltG1szODsy
OzEwMDsyNDk7MzRtIBtbMzltG1szODsyOzEwNDsyNDc7MzFtIBtbMzltG1szODsyOzEwOTsyNDY7
MjhtXxtbMzltG1szODsyOzExMzsyNDQ7MjZtXxtbMzltG1szODsyOzExNzsyNDI7MjNtfBtbMzlt
G1szODsyOzEyMTsyNDA7MjFtIBtbMzltG1szODsyOzEyNTsyMzk7MTltfBtbMzltG1szODsyOzEz
MDsyMzY7MTZtIBtbMzltG1szODsyOzEzNDsyMzQ7MTRtIBtbMzltG1szODsyOzEzODsyMzI7MTNt
IBtbMzltG1szODsyOzE0MjsyMjk7MTFtIBtbMzltG1szODsyOzE0NzsyMjc7OW0gG1szOW0bWzM4
OzI7MTUxOzIyNDs4bXwbWzM5bRtbMzg7MjsxNTU7MjIxOzZtIBtbMzltG1szODsyOzE1OTsyMTg7
NW0gG1szOW0bWzM4OzI7MTYzOzIxNTs0bV8bWzM5bRtbMzg7MjsxNjc7MjEyOzNtXxtbMzltG1sz
ODsyOzE3MTsyMDk7Mm1fG1szOW0bWzM4OzI7MTc1OzIwNjsybSAbWzM5bRtbMzg7MjsxNzk7MjAy
OzFtIBtbMzltG1szODsyOzE4MzsxOTk7MW18G1szOW0bWzM4OzI7MTg3OzE5NTsxbRtbMzltChtb
Mzg7MjsxMDsxNDY7MjI3bXwbWzM5bRtbMzg7Mjs4OzE1MDsyMjRtIBtbMzltG1szODsyOzc7MTU0
OzIyMm18G1szOW0bWzM4OzI7NTsxNTg7MjE5bSAbWzM5bRtbMzg7Mjs0OzE2MjsyMTZtXBtbMzlt
G1szODsyOzM7MTY2OzIxM20gG1szOW0bWzM4OzI7MzsxNzA7MjEwbSAbWzM5bRtbMzg7MjsyOzE3
NDsyMDZtIBtbMzltG1szODsyOzE7MTc4OzIwM218G1szOW0bWzM4OzI7MTsxODI7MTk5bSAbWzM5
bRtbMzg7MjsxOzE4NjsxOTZtIBtbMzltG1szODsyOzE7MTkwOzE5Mm0gG1szOW0bWzM4OzI7MTsx
OTM7MTg5bSAbWzM5bRtbMzg7MjsxOzE5NzsxODVtIBtbMzltG1szODsyOzE7MjAwOzE4MW0pG1sz
OW0bWzM4OzI7MTsyMDQ7MTc3bSAbWzM5bRtbMzg7MjsyOzIwNzsxNzNtfBtbMzltG1szODsyOzM7
MjEwOzE2OW0gG1szOW0bWzM4OzI7NDsyMTQ7MTY1bSgbWzM5bRtbMzg7Mjs1OzIxNzsxNjFtIBtb
MzltG1szODsyOzY7MjIwOzE1N20gG1szOW0bWzM4OzI7NzsyMjI7MTUzbSAbWzM5bRtbMzg7Mjs4
OzIyNTsxNDltIBtbMzltG1szODsyOzEwOzIyODsxNDVtIBtbMzltG1szODsyOzEyOzIzMDsxNDBt
IBtbMzltG1szODsyOzEzOzIzMzsxMzZtIBtbMzltG1szODsyOzE1OzIzNTsxMzJtIBtbMzltG1sz
ODsyOzE3OzIzNzsxMjhtIBtbMzltG1szODsyOzIwOzIzOTsxMjRtIBtbMzltG1szODsyOzIyOzI0
MTsxMTltIBtbMzltG1szODsyOzI0OzI0MzsxMTVtIBtbMzltG1szODsyOzI3OzI0NTsxMTFtIBtb
MzltG1szODsyOzI5OzI0NjsxMDdtIBtbMzltG1szODsyOzMyOzI0ODsxMDNtKRtbMzltG1szODsy
OzM1OzI0OTs5OG0gG1szOW0bWzM4OzI7Mzg7MjUwOzk0bXwbWzM5bRtbMzg7Mjs0MTsyNTE7OTBt
IBtbMzltG1szODsyOzQ0OzI1Mjs4Nm0oG1szOW0bWzM4OzI7NDc7MjUzOzgybSAbWzM5bRtbMzg7
Mjs1MTsyNTM7NzhtIBtbMzltG1szODsyOzU0OzI1NDs3NG0gG1szOW0bWzM4OzI7NTg7MjU0Ozcx
bSAbWzM5bRtbMzg7Mjs2MTsyNTQ7NjdtIBtbMzltG1szODsyOzY1OzI1NDs2M218G1szOW0bWzM4
OzI7Njk7MjU0OzYwbSAbWzM5bRtbMzg7Mjs3MjsyNTQ7NTZtKBtbMzltG1szODsyOzc2OzI1NDs1
M20gG1szOW0bWzM4OzI7ODA7MjUzOzQ5bSAbWzM5bRtbMzg7Mjs4NDsyNTM7NDZtIBtbMzltG1sz
ODsyOzg4OzI1Mjs0M20pG1szOW0bWzM4OzI7OTI7MjUxOzQwbSAbWzM5bRtbMzg7Mjs5NjsyNTA7
MzdtfBtbMzltG1szODsyOzEwMDsyNDk7MzRtIBtbMzltG1szODsyOzEwNDsyNDc7MzFtKBtbMzlt
G1szODsyOzEwOTsyNDY7MjhtXBtbMzltG1szODsyOzExMzsyNDQ7MjZtIBtbMzltG1szODsyOzEx
NzsyNDI7MjNtKBtbMzltG1szODsyOzEyMTsyNDA7MjFtIBtbMzltG1szODsyOzEyNTsyMzk7MTlt
IBtbMzltG1szODsyOzEzMDsyMzY7MTZtfBtbMzltG1szODsyOzEzNDsyMzQ7MTRtIBtbMzltG1sz
ODsyOzEzODsyMzI7MTNtfBtbMzltG1szODsyOzE0MjsyMjk7MTFtIBtbMzltG1szODsyOzE0Nzsy
Mjc7OW0gG1szOW0bWzM4OzI7MTUxOzIyNDs4bSAbWzM5bRtbMzg7MjsxNTU7MjIxOzZtIBtbMzlt
G1szODsyOzE1OTsyMTg7NW0gG1szOW0bWzM4OzI7MTYzOzIxNTs0bXwbWzM5bRtbMzg7MjsxNjc7
MjEyOzNtIBtbMzltG1szODsyOzE3MTsyMDk7Mm0oG1szOW0bWzM4OzI7MTc1OzIwNjsybSAbWzM5
bRtbMzg7MjsxNzk7MjAyOzFtIBtbMzltG1szODsyOzE4MzsxOTk7MW0gG1szOW0bWzM4OzI7MTg3
OzE5NTsxbSkbWzM5bRtbMzg7MjsxOTA7MTkyOzFtIBtbMzltG1szODsyOzE5NDsxODg7MW18G1sz
OW0bWzM4OzI7MTk3OzE4NDsxbRtbMzltChtbMzg7Mjs1OzE1ODsyMTltfBtbMzltG1szODsyOzQ7
MTYyOzIxNm0gG1szOW0bWzM4OzI7MzsxNjY7MjEzbSkbWzM5bRtbMzg7MjszOzE3MDsyMTBtIBtb
MzltG1szODsyOzI7MTc0OzIwNm0gG1szOW0bWzM4OzI7MTsxNzg7MjAzbVwbWzM5bRtbMzg7Mjsx
OzE4MjsxOTltIBtbMzltG1szODsyOzE7MTg2OzE5Nm0gG1szOW0bWzM4OzI7MTsxOTA7MTkybS8b
WzM5bRtbMzg7MjsxOzE5MzsxODltXBtbMzltG1szODsyOzE7MTk3OzE4NW1fG1szOW0bWzM4OzI7
MTsyMDA7MTgxbV8bWzM5bRtbMzg7MjsxOzIwNDsxNzdtXxtbMzltG1szODsyOzI7MjA3OzE3M21f
G1szOW0bWzM4OzI7MzsyMTA7MTY5bSkbWzM5bRtbMzg7Mjs0OzIxNDsxNjVtIBtbMzltG1szODsy
OzU7MjE3OzE2MW18G1szOW0bWzM4OzI7NjsyMjA7MTU3bSAbWzM5bRtbMzg7Mjs3OzIyMjsxNTNt
KBtbMzltG1szODsyOzg7MjI1OzE0OW1fG1szOW0bWzM4OzI7MTA7MjI4OzE0NW1fG1szOW0bWzM4
OzI7MTI7MjMwOzE0MG1fG1szOW0bWzM4OzI7MTM7MjMzOzEzNm1fG1szOW0bWzM4OzI7MTU7MjM1
OzEzMm0vG1szOW0bWzM4OzI7MTc7MjM3OzEyOG1cG1szOW0bWzM4OzI7MjA7MjM5OzEyNG0gG1sz
OW0bWzM4OzI7MjI7MjQxOzExOW0gG1szOW0bWzM4OzI7MjQ7MjQzOzExNW0vG1szOW0bWzM4OzI7
Mjc7MjQ1OzExMW1cG1szOW0bWzM4OzI7Mjk7MjQ2OzEwN21fG1szOW0bWzM4OzI7MzI7MjQ4OzEw
M21fG1szOW0bWzM4OzI7MzU7MjQ5Ozk4bV8bWzM5bRtbMzg7MjszODsyNTA7OTRtXxtbMzltG1sz
ODsyOzQxOzI1MTs5MG0pG1szOW0bWzM4OzI7NDQ7MjUyOzg2bSAbWzM5bRtbMzg7Mjs0NzsyNTM7
ODJtfBtbMzltG1szODsyOzUxOzI1Mzs3OG0gG1szOW0bWzM4OzI7NTQ7MjU0Ozc0bSgbWzM5bRtb
Mzg7Mjs1ODsyNTQ7NzFtXxtbMzltG1szODsyOzYxOzI1NDs2N21fG1szOW0bWzM4OzI7NjU7MjU0
OzYzbV8bWzM5bRtbMzg7Mjs2OTsyNTQ7NjBtXxtbMzltG1szODsyOzcyOzI1NDs1Nm0vG1szOW0b
WzM4OzI7NzY7MjU0OzUzbXwbWzM5bRtbMzg7Mjs4MDsyNTM7NDltIBtbMzltG1szODsyOzg0OzI1
Mzs0Nm0pG1szOW0bWzM4OzI7ODg7MjUyOzQzbSAbWzM5bRtbMzg7Mjs5MjsyNTE7NDBtIBtbMzlt
G1szODsyOzk2OzI1MDszN20gG1szOW0bWzM4OzI7MTAwOzI0OTszNG0oG1szOW0bWzM4OzI7MTA0
OzI0NzszMW0gG1szOW0bWzM4OzI7MTA5OzI0NjsyOG18G1szOW0bWzM4OzI7MTEzOzI0NDsyNm0g
G1szOW0bWzM4OzI7MTE3OzI0MjsyM20pG1szOW0bWzM4OzI7MTIxOzI0MDsyMW0gG1szOW0bWzM4
OzI7MTI1OzIzOTsxOW1cG1szOW0bWzM4OzI7MTMwOzIzNjsxNm0gG1szOW0bWzM4OzI7MTM0OzIz
NDsxNG1cG1szOW0bWzM4OzI7MTM4OzIzMjsxM21fG1szOW0bWzM4OzI7MTQyOzIyOTsxMW18G1sz
OW0bWzM4OzI7MTQ3OzIyNzs5bSAbWzM5bRtbMzg7MjsxNTE7MjI0OzhtKBtbMzltG1szODsyOzE1
NTsyMjE7Nm1fG1szOW0bWzM4OzI7MTU5OzIxODs1bV8bWzM5bRtbMzg7MjsxNjM7MjE1OzRtXxtb
MzltG1szODsyOzE2NzsyMTI7M21fG1szOW0bWzM4OzI7MTcxOzIwOTsybS8bWzM5bRtbMzg7Mjsx
NzU7MjA2OzJtfBtbMzltG1szODsyOzE3OTsyMDI7MW0gG1szOW0bWzM4OzI7MTgzOzE5OTsxbSkb
WzM5bRtbMzg7MjsxODc7MTk1OzFtIBtbMzltG1szODsyOzE5MDsxOTI7MW0gG1szOW0bWzM4OzI7
MTk0OzE4ODsxbSAbWzM5bRtbMzg7MjsxOTc7MTg0OzFtKBtbMzltG1szODsyOzIwMTsxODA7MW0g
G1szOW0bWzM4OzI7MjA0OzE3NzsybXwbWzM5bRtbMzg7MjsyMDg7MTczOzJtG1szOW0KG1szODsy
OzM7MTcwOzIxMG18G1szOW0bWzM4OzI7MjsxNzQ7MjA2bS8bWzM5bRtbMzg7MjsxOzE3ODsyMDNt
IBtbMzltG1szODsyOzE7MTgyOzE5OW0gG1szOW0bWzM4OzI7MTsxODY7MTk2bSAbWzM5bRtbMzg7
MjsxOzE5MDsxOTJtIBtbMzltG1szODsyOzE7MTkzOzE4OW0pG1szOW0bWzM4OzI7MTsxOTc7MTg1
bV8bWzM5bRtbMzg7MjsxOzIwMDsxODFtXBtbMzltG1szODsyOzE7MjA0OzE3N21fG1szOW0bWzM4
OzI7MjsyMDc7MTczbV8bWzM5bRtbMzg7MjszOzIxMDsxNjltXxtbMzltG1szODsyOzQ7MjE0OzE2
NW1fG1szOW0bWzM4OzI7NTsyMTc7MTYxbV8bWzM5bRtbMzg7Mjs2OzIyMDsxNTdtXxtbMzltG1sz
ODsyOzc7MjIyOzE1M21fG1szOW0bWzM4OzI7ODsyMjU7MTQ5bSgbWzM5bRtbMzg7MjsxMDsyMjg7
MTQ1bV8bWzM5bRtbMzg7MjsxMjsyMzA7MTQwbV8bWzM5bRtbMzg7MjsxMzsyMzM7MTM2bV8bWzM5
bRtbMzg7MjsxNTsyMzU7MTMybV8bWzM5bRtbMzg7MjsxNzsyMzc7MTI4bV8bWzM5bRtbMzg7Mjsy
MDsyMzk7MTI0bV8bWzM5bRtbMzg7MjsyMjsyNDE7MTE5bV8bWzM5bRtbMzg7MjsyNDsyNDM7MTE1
bS8bWzM5bRtbMzg7MjsyNzsyNDU7MTExbSAbWzM5bRtbMzg7MjsyOTsyNDY7MTA3bSAbWzM5bRtb
Mzg7MjszMjsyNDg7MTAzbVwbWzM5bRtbMzg7MjszNTsyNDk7OThtXxtbMzltG1szODsyOzM4OzI1
MDs5NG1fG1szOW0bWzM4OzI7NDE7MjUxOzkwbV8bWzM5bRtbMzg7Mjs0NDsyNTI7ODZtXxtbMzlt
G1szODsyOzQ3OzI1Mzs4Mm1fG1szOW0bWzM4OzI7NTE7MjUzOzc4bV8bWzM5bRtbMzg7Mjs1NDsy
NTQ7NzRtXxtbMzltG1szODsyOzU4OzI1NDs3MW0oG1szOW0bWzM4OzI7NjE7MjU0OzY3bV8bWzM5
bRtbMzg7Mjs2NTsyNTQ7NjNtXxtbMzltG1szODsyOzY5OzI1NDs2MG1fG1szOW0bWzM4OzI7NzI7
MjU0OzU2bV8bWzM5bRtbMzg7Mjs3NjsyNTQ7NTNtXxtbMzltG1szODsyOzgwOzI1Mzs0OW1fG1sz
OW0bWzM4OzI7ODQ7MjUzOzQ2bV8bWzM5bRtbMzg7Mjs4ODsyNTI7NDNtfBtbMzltG1szODsyOzky
OzI1MTs0MG0vG1szOW0bWzM4OzI7OTY7MjUwOzM3bSAbWzM5bRtbMzg7MjsxMDA7MjQ5OzM0bSAb
WzM5bRtbMzg7MjsxMDQ7MjQ3OzMxbSAbWzM5bRtbMzg7MjsxMDk7MjQ2OzI4bSAbWzM5bRtbMzg7
MjsxMTM7MjQ0OzI2bSAbWzM5bRtbMzg7MjsxMTc7MjQyOzIzbVwbWzM5bRtbMzg7MjsxMjE7MjQw
OzIxbXwbWzM5bRtbMzg7MjsxMjU7MjM5OzE5bS8bWzM5bRtbMzg7MjsxMzA7MjM2OzE2bSAbWzM5
bRtbMzg7MjsxMzQ7MjM0OzE0bSAbWzM5bRtbMzg7MjsxMzg7MjMyOzEzbSAbWzM5bRtbMzg7Mjsx
NDI7MjI5OzExbVwbWzM5bRtbMzg7MjsxNDc7MjI3OzltXxtbMzltG1szODsyOzE1MTsyMjQ7OG1f
G1szOW0bWzM4OzI7MTU1OzIyMTs2bSgbWzM5bRtbMzg7MjsxNTk7MjE4OzVtXxtbMzltG1szODsy
OzE2MzsyMTU7NG1fG1szOW0bWzM4OzI7MTY3OzIxMjszbV8bWzM5bRtbMzg7MjsxNzE7MjA5OzJt
XxtbMzltG1szODsyOzE3NTsyMDY7Mm1fG1szOW0bWzM4OzI7MTc5OzIwMjsxbV8bWzM5bRtbMzg7
MjsxODM7MTk5OzFtXxtbMzltG1szODsyOzE4NzsxOTU7MW18G1szOW0bWzM4OzI7MTkwOzE5Mjsx
bS8bWzM5bRtbMzg7MjsxOTQ7MTg4OzFtIBtbMzltG1szODsyOzE5NzsxODQ7MW0gG1szOW0bWzM4
OzI7MjAxOzE4MDsxbSAbWzM5bRtbMzg7MjsyMDQ7MTc3OzJtIBtbMzltG1szODsyOzIwODsxNzM7
Mm0gG1szOW0bWzM4OzI7MjExOzE2OTszbVwbWzM5bRtbMzg7MjsyMTQ7MTY1OzRtfBtbMzltG1sz
ODsyOzIxNzsxNjE7NW0bWzM5bQo=
" | base64 -d
    echo "         Version: $VERSION"
    echo "          Author: $AUTHOR "
    echo ""

}

help(){
    echo 'usage: ./nse-search [OPTIONS] {PATTERN}'
    echo 'Options: '
    echo "     -s,--script <script/pattern>     : Search for a script at $NSE_SCRIPTS"
    echo "     -S,--service <service/pattern>   : Search for a service at $NSE_SERVICES"
    echo "     -p,--protocol <protocol/pattern> : Search for a protocol at $NSE_PROTOCOLS"
    echo "     -m,--mac <mac/vendor/pattern>    : Search for a mac at $NSE_MAC"
    exit 0
}

usage(){
    echo "No usage messages yet"
    exit 0
}

ERROR(){
    echo -e "[X] \e[0;32mError...\e[0m"
    echo "[*] Function: $1"
    echo "[*] Reason:   $2"
    echo "[X] Returning errorcode 1"
    exit 1
}

check_updates(){
    ## Updating remote repo
    git remote update
    if [[ $? -ne 0 ]];then
	echo "[!] Unable to update remote repo"
	return 0
    fi

    if [[ -n $( git status -uno | grep -o "Your branch is behind" ) ]];then
	echo "[#] Updates are available..."
	select var in Update Continue Exit
	do
	    if [[ $var == "Update" ]];then     # Updating program
		git pull origin master
		echo "[!] Program is updated"
		exit 0
	    elif [[ $var == "Continue" ]];then # Continue execution Normally
		break
	    elif [[ $var == "Exit" ]];then     # Exit
		exit 0
	    fi
	done
    fi

    return 0
}

argument_parser(){
    ## help if there is no arguments
    if [[ $# -eq 0 ]];then
	help
    fi

    ## Parsing arguments
    while [[ $# -gt 0 ]];do
	case $1 in
	    -s|--script) SCRIPT=$2 && shift && shift ;;
	    -S|--service) SERVICE=$2 && shift && shift ;;
	    -p|--protocol) PROTOCOL=$2 && shift && shift ;;
	    -m|--mac) MAC=$2 && shift && shift ;;
	    --usage) usage ;;
	    -h|--help) help ;;
	    *) help;;
	esac
    done

    ## Setting up default variables
    echo ${SCRIPT:=""}       &>/dev/null
    echo ${SERVICE:=""}      &>/dev/null
    echo ${PROTOCOL:=""}     &>/dev/null
    echo ${MAC:=""}          &>/dev/null
}

#############################
##    CHECKING AREA        ##
#############################  

argument_checker(){
    ## Checking nmap installation
    argument_checker_requeriments

    ## Checking files
    argument_checker_nmap_files

    ## Checking script existence
    argument_checker_script_existence
}

argument_checker_requeriments(){
    ## nmap installation check
    which nmap &>/dev/null
    if [[ $? -ne 0 ]];then # using which
	apt-cache policy nmap &>/dev/null
	if [[ $? -ne 0 ]];then # using apt
	    pacman -Q nmap &>/dev/null
	    if [[ $? -ne 0 ]];then # using nmap
		ERROR "argument_checker_requeriments" "nmap is not installed"
	    fi
	fi
    fi
}

argument_checker_nmap_files(){
    ## Checking /usr/share/nmap/scripts files
    local lista=("$NSE_SCRIPTS" "$NSE_SERVICES" "$NSE_PROTOCOLS" "$NSE_MAC")
    for i in ${lista[@]};do
	if [[ ! -e $i ]];then
	    ERROR "argument_checker_nmap_files" "Can't find nmap file $i"
	fi
    done
}

argument_checker_script_existence(){
    ## Checking if $SCRIPT string exist inside /usr/share/nmap/scripts/script.db
    if [[ -z $(cat $NSE_SCRIPTS_DB | grep -o "$SCRIPT") ]];then
	ERROR "argument_checker_script_existence" "No entries matched inside script.db"
    fi
}

#############################
##   PROCESSING AREA       ##
#############################

argument_processor(){
    ## Processing script
    if [[ -n "$SCRIPT" ]];then
	category_check "$SCRIPT"
	if [[ $result_code -eq 0 ]];then
	    parse_filename_print_DB "$SCRIPT"
	else
	    parse_category_print_DB "$SCRIPT"
	fi
    fi

    ## Processing SERVICE
    if [[ -n "$SERVICE" ]];then
	printFile "$NSE_SERVICES" "$SERVICE"
    fi

    ## Processing PROTOCOL
    if [[ -n "$PROTOCOL" ]];then
	printFile "$NSE_PROTOCOLS" "$PROTOCOL"
    fi

    ## Processing MAC
    if [[ -n "$MAC" ]];then
	printFile "$NSE_MAC" "$MAC"
    fi
}

category_check(){
    ## Check if the user is searching for script or category
    category_list=("auth" "broadcast" "brute" "default" "discovery" "dos" \
			 "exploit" "external" "fuzzer" "intrusive" "malware" \
			 "safe" "version" "vuln")
    aux=$(echo "${category_list[@]}" | grep -o "$1")
    if [[ -z ${aux}  ]];then
	result_code=0
    else
	result_code=1
    fi

 }
    
parse_filename_print_DB(){
    ## Extracting Filename
    filename=( $(cat "$NSE_SCRIPTS_DB" | tr -d "\"" | \
		   grep -o -E "filename = .*${1}[a-zA-Z0-9\-]*" | \
		   cut -d " " -f 3 | tr "\n" " ") )
    
    ## Extracting category
    category=($(cat "$NSE_SCRIPTS_DB" | tr -d "\"" | grep "${1}" | \
		    grep -o -E "categories = \{[0-9a-zA-Z\ \,]*\}" | \
		    tr " " "?" | tr "\n" " "))
    loop_num=$((${#category[@]} - 1))
    for i in $(seq 0 $loop_num);do
	category[$i]=$(echo "${category[$i]}" | tr "?" " ")
    done
    
    ## Printing formated output
    for i in $(seq 0 "$loop_num");do
	printf "%-35s %-30s\n" "${filename[$i]}" "${category[$i]}"
    done | nl | grep "$1" --color=always
    
}

parse_category_print_DB(){
    filename=($(cat "$NSE_SCRIPTS_DB" | grep $1 | cut -d " " -f 5 | tr -d "\"" | tr -d "," | cut -d "." -f 1))
    category=($(cat "$NSE_SCRIPTS_DB" | grep $1 | cut -d " " -f 6- | tr -d "\""  | tr " " "?" ))
    loop_num=$((${#category[@]} - 1))
    for i in $(seq 0 $loop_num);do
	category[$i]=$(echo "${category[$i]}" | tr "?" " ")
    done    

    ## Printing formated output
    for i in $(seq 0 "$loop_num");do
	printf "%-35s %-30s\n" "${filename[$i]}" "${category[$i]}"
    done | nl | grep "$1" --color=always
    
}

 

printFile(){
    # $1 = FILEPATH
    # $2 = PATTERN
    echo -e "\e[0;31m[*] Listing matches found in $NSE_SCRIPTS:\e[0m"    
    if [[ -d $1 ]];then    
	ls "$1" | grep --ignore-case "$2" --color=always | nl
    else
	cat "$1" | grep --ignore-case "$2" --color=always | tr "\t" " " | nl
    fi
}

check_updates
banner
argument_parser "$@"
argument_checker
argument_processor
exit 0

## Do a online search utility
