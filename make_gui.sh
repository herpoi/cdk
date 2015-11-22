#!/bin/bash
# based on the original make.sh
# Author: TangoCash
# Last modified: 15.06.14
##############################################
setparameters() {

DIALOG=${DIALOG:-`which dialog`}
tempfile=/tmp/test$$
height=30
width=65
listheight=25

if [ -z "${DIALOG}" ]; then
	echo "Please install dialog package." 1>&2
	exit 1
fi

MAKEPARAM=""
}
##############################################
greetings() {
${DIALOG} --msgbox \
"\n\
  _______                     _____              _     _         _\n\
 |__   __|                   |  __ \            | |   | |       | |\n\
    | | ___  __ _ _ __ ___   | |  | |_   _  ____| | __| |_  __ _| | ___ ___\n\
    | |/ _ \/ _\` | '_ \` _ \  | |  | | | | |/  __| |/ /| __|/ _\` | |/ _ | __|\n\
    | |  __/ (_| | | | | | | | |__| | |_| |  (__|   < | |_| (_| | |  __|__ \\\n\
    |_|\___|\__,_|_| |_| |_| |_____/ \__,_|\____|_|\_\ \__|\__,_|_|\___|___/\n\
\n\
                     Press OK to configure your environment\n" 0 0
clear
}
##############################################
configmenu() {
${DIALOG} --menu "\n Select Target:\n " $height $width $listheight \
1	"Kathrein UFS-910" \
3	"Kathrein UFS-912" \
4	"Kathrein UFS-922" \
5	"Topfield 7700 HDPVR" \
6	"Fortis based (HDBOX)" \
7	"SpiderBox HL-101" \
8	"Edision Argus vip" \
9	"Cuberevo (IPBOX 9000)" \
10	"Cuberevo mini (IPBOX 900)" \
11	"Cuberevo mini2 (IPBOX 910)" \
12	"Cuberevo 250 (IPBOX 91)" \
13	"Cuberevo 9500HD (7000HD)" \
14	"Cuberevo 2000HD" \
15	"Cuberevo mini_fta (200HD)" \
16	"Homecast 5101" \
17	"Octagon 1008" \
18	"SPARK" \
19	"Atevio7500" \
20	"SPARK7162" \
21	"IPBOX9900" \
22	"IPBOX99" \
23	"IPBOX55" \
24	"Fortis HS7810A" \
25	"B4Team ADB 5800S" \
26	"Fortis HS7110" \
27	"Atemio520" \
28	"Kathrein UFS-913" \
29	"Kathrein UFC-960" \
30	"Vitamin HD5000" \
31	"Atemio530" \
32	"SagemCom 88 series" \
33	"Ferguson Ariva @Link 200" \
34	"Fortis HS7119 (not finished yet)" \
35	"Fortis HS7819 (not finished yet)" \
36	"Fortis DP7000 (not finished yet)" \
37	"Xsarius Alpha (Cuberevo 3000HD)" \
2> ${tempfile}

opt=${?}
if [ $opt != 0 ]; then cleanup; exit; fi

REPLY=`cat $tempfile`

MAKEPARAM="$MAKEPARAM $REPLY "
clear

##############################################

${DIALOG} --menu "\n Select Kernel: \n " $height $width $listheight \
1	"STM 24 P0209" \
2	"STM 24 P0211 (recommended)" \
3	"STM 24 P0214 (experimental)" \
4	"STM 24 P0215 (experimental)" \
2> ${tempfile}

opt=${?}
if [ $opt != 0 ]; then cleanup; exit; fi

REPLY=`cat $tempfile`

MAKEPARAM="$MAKEPARAM $REPLY "
clear

##############################################

${DIALOG} --defaultno --yesno "\n Kernel Debug: \n Activate debug (y/N)? \n" 0 0
REPLY=${?}
DEBUG="N"
[ "$REPLY" == "0" ] && DEBUG="Y"
MAKEPARAM="$MAKEPARAM $DEBUG "
clear

##############################################

${DIALOG} --menu "\n Select Player: \n " $height $width $listheight \
1	"Player 191 (stmfb-3.1_stm24_0102)" \
2	"Player 191 (stmfb-3.1_stm24_0104, recommended)" \
2> ${tempfile}

opt=${?}
if [ $opt != 0 ]; then cleanup; exit; fi

REPLY=`cat $tempfile`

MAKEPARAM="$MAKEPARAM $REPLY "
clear
##############################################

${DIALOG} --menu "\n Select Media Framework: \n " $height $width $listheight \
1	"eplayer3" \
2	"gstreamer (E2)" \
3	"use build-in (NMP / NHD2)" \
4	"all" \
2> ${tempfile}

opt=${?}
if [ $opt != 0 ]; then cleanup; exit; fi

REPLY=`cat $tempfile`

MAKEPARAM="$MAKEPARAM $REPLY "
clear

##############################################

${DIALOG} --defaultno --yesno "\n External LCD support: \n Activate (y/N)? \n" 0 0
REPLY=${?}
LCD="1"
[ "$REPLY" == "0" ] && LCD="2"
MAKEPARAM="$MAKEPARAM $LCD "
clear

##############################################

${DIALOG} --menu "\n Select to build: \n " $height $width $listheight \
1	"Neutrino" \
2	"Enigma2 + WLAN" \
2> ${tempfile}

opt=${?}
if [ $opt != 0 ]; then cleanup; exit; fi

REPLY=`cat $tempfile`

MAKEPARAM="$MAKEPARAM $REPLY "
clear
##############################################
} #closing bracket configmenu
##############################################
doconfig() {
##############################################

#${DIALOG} --msgbox "$MAKEPARAM" 0 0

##############################################

./make.sh $MAKEPARAM 2>&1 | ${DIALOG} --progressbox "configuring... please wait...." 40 120

##############################################

}
##############################################
mainmenu() {
clear
${DIALOG} --cancel-label "Exit" --menu \
"\n\
********************************************************************************************\n\
*                                                                                          *\n\
*  SSSSSSSS\\                                       SSSSSS\\                      SS\\        *\n\
*  \\__SS  __|                                     SS  __SS\\                     SS |       *\n\
*     SS | SSSSSS\\  SSSSSSS\\   SSSSSS\\   SSSSSS\\  SS /  \\__| SSSSSS\\   SSSSSSS\\ SSSSSSS\\   *\n\
*     SS | \\____SS\\ SS  __SS\\ SS  __SS\\ SS  __SS\\ SS |       \\____SS\\ SS  _____|SS  __SS\\  *\n\
*     SS | SSSSSSS |SS |  SS |SS /  SS |SS /  SS |SS |       SSSSSSS |\\SSSSSS\\  SS |  SS | *\n\
*     SS |SS  __SS |SS |  SS |SS |  SS |SS |  SS |SS |  SS\\ SS  __SS | \\____SS\\ SS |  SS | *\n\
*     SS |\\SSSSSSS |SS |  SS |\\SSSSSSS |\\SSSSSS  |\\SSSSSS  |\\SSSSSSS |SSSSSSS  |SS |  SS | *\n\
*     \\__| \\_______|\\__|  \\__| \\____SS | \\______/  \\______/  \\_______|\\_______/ \\__|  \\__| *\n\
*                             SS\\   SS |                                                   *\n\
*                             \\SSSSSS  |                                                   *\n\
*                              \\______/                                                    *\n\
*                                                                                          *\n\
********************************************************************************************\n\
                            ----------------------------------------\n\
                            Your Duckbox Development Toolchain is ready :-)\n\
                            Your next step could be:\n\
                            ----------------------------------------\n" 0 0 0 \
1	"Build Neutrino-MP" \
2	"Build Neutrino HD2" \
3	"Build Flashimage" \
4	"Quick Cleanup" \
5	"Complete Cleanup" \
6	"Reconfigure Build Environment" \
-	"---(not maintained)---" \
97	"Build Neutrino (old)" \
99	"Build Enigma2 (pli-nightly)" \
2> ${tempfile}

opt=${?}
if [ $opt != 0 ]; then cleanup; exit; fi

REPLY=`cat $tempfile`

case "$REPLY" in
	1) MKTARGET="yaud-none lirc boot-elf remote firstboot"
	   #MKTARGET="$MKTARGET neutrino-mp"
	   selectbranch
	   addons
	   MKTARGET="$MKTARGET release_neutrino"
	   makeyaud;;
	2) MKTARGET="yaud-neutrino-hd2-exp"
	   makeyaud;;
	3) MKTARGET=""
	   makeflash;;
	4) MKTARGET="clean"
	   makeyaud;;
	5) MKTARGET="distclean"
	   makeyaud;;
	6) configmenu
	   doconfig;;
	97) MKTARGET="yaud-neutrino"
	    makeyaud;;
	99) MKTARGET="yaud-enigma2-pli-nightly"
	    makeyaud;;
	255) cleanup && exit;;
	*) MKTARGET="";;
esac
}
##############################################
makeflash() {
if [ -d ../tufsbox/release_neutrino ]; then
	BOXTYPE=`cat ../tufsbox/release_neutrino/var/etc/hostname`
else
	BOXTYPE=`cat ../tufsbox/release/etc/hostname`
fi

if [ "$BOXTYPE" = "" ]; then
	${DIALOG} --msgbox "No Target build to create Flashimage" 0 0
	cleanup
else
	if [ -e ../flash/$BOXTYPE/$BOXTYPE.sh ]; then
	 ${DIALOG} --insecure --passwordbox "sudo password to run flashscript ?" 0 0 2> $tempfile
	 cd ../flash/$BOXTYPE
	 echo `cat $tempfile` | sudo -S ./$BOXTYPE.sh 2>&1 | ${DIALOG} --programbox "preparing flashimage... please wait...." 40 120
	fi
	if [ -e ../flash/$BOXTYPE/make_flash.sh ]; then
	 ${DIALOG} --insecure --passwordbox "sudo password to run flashscript ?" 0 0 2> $tempfile
	 cd ../flash/$BOXTYPE
	 echo `cat $tempfile` | sudo -S ./make_flash.sh 2>&1 | ${DIALOG} --programbox "preparing flashimage... please wait...." 40 120
	fi
	
	cd $CURDIR
	cleanup
fi
}
##############################################
selectbranch() {
BRANCH=`${DIALOG} --radiolist "\n Select Neutrino-MP Branch: \n " $height $width $listheight \
1	"Master" off \
2	"Next" on \
3>&1 1>&2 2>&3`

for i in $BRANCH; do
   case "$i" in
      1 ) MKTARGET="$MKTARGET neutrino-mp";;
      2 ) MKTARGET="$MKTARGET neutrino-mp-next";;
   esac
done
clear
}
##############################################
addons() {
ADDONS=`${DIALOG} --checklist "\n Select Addons to build: \n " $height $width $listheight \
1	"Plugins" off \
2	"Apple Airplay" off \
3>&1 1>&2 2>&3`

for i in $ADDONS; do
   case "$i" in
      \"1\" ) MKTARGET="$MKTARGET neutrino-mp-plugins";;
      \"2\" ) MKTARGET="$MKTARGET shairport";;
   esac
done

clear
}
##############################################
makeyaud() {
make --no-print-directory --silent ${MKTARGET} 2>&1 | tee make.log | ${DIALOG} --programbox "compiling... please wait...." 40 120
#${DIALOG} --pause "$MKTARGET" $height $width 10
}
##############################################
cleanup() {
rm $tempfile
clear
}
##############################################
setparameters
greetings
if [ -e config.status ]; then
	${DIALOG} --defaultno --yesno "\n Existing configuration found: \n Configure new (y/N)? \n" 0 0
	REPLY=${?}
	[ "$REPLY" == "0" ] && configmenu && doconfig
else
	configmenu
	doconfig
fi

while true; do
	mainmenu
done

cleanup
##############################################
