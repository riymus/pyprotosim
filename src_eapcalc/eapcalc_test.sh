#!/bin/sh
######################################################################
# Copyright (c) 2012-2013, Sergej Srepfler <sergej.srepfler@gmail.com>
# Started at February 2012
# Version 0.2.3, Last change on Apr 20, 2014
# This software is distributed under the terms of BSD license.
######################################################################

# To enable shell debugging insert "set -x" where needed
# To disable shell debugging insert "set +x" where needed

# Verify that value exist
checkIfExist () {
  if [ "$1" = "$2" ] 
  then
    OK="X$OK"
  fi
#  echo "OK is ",$OK
}

# For N successful tests there should be N Xes
checkResult () {
  if [ "$2" = "$3" ]
  then
    echo "$1 PASSED"
  else
    echo "$1 FAILED!!!!!!!!"
  fi
}

# Detect target system (currently only tested on XP)
TARGET=`set |grep "^OS="`
if [ "$TARGET" = "OS=Windows_NT" ]
then 
    # Change to calc.exe for Windows
    EXE="eapcalc.exe"
else
    # Linux, Solaris
    EXE="./eapcalc"
fi

##############################
# SIM calculation
##############################
ident="1385913234960000"
nonc="0x3333333333333333FFFFFFFFFFFFFFFF"
sel=1
ver="0x0001"
kc="0x666238366439333738326161373566656238386464653763"
RES=`$EXE sim $ident $kc $nonc $ver $sel `
OK=""
for p in $RES
do
  checkIfExist $p MK=E896B7C35F8294F8C416B7C5553030549451FD26
  checkIfExist $p KENCR=F94440C6E48946802CA208A402103BBB 
  checkIfExist $p KAUT=082FB77427E87A82E9F14C1F09977524 
  checkIfExist $p MSK=5EFA3A8889D125AF4AA778414028B2CD61AD5CFCC4EC0035E4334822649F44858B933DB191FD811BB1021F195B5280B6FB38846709A511AEF35512987F05984B 
  checkIfExist $p EMSK=B6E1FBE466C44788BFF5A4EFE76BE537FC814FA4FB04A1837036764FD7821A32216CDF874482C7291A97109D57B1209999A12575CA14C08EFD437DCFF178C70E
done
checkResult "SIM" $OK "XXXXX"

##############################
# AKA Calculation
##############################
identity="0111122223333456@wlan.mnc111.mcc222.3gppnetwork.org"
ck="0x12345678901234567890123456789012"
ik="0xaabbccddeeffaabbccddeeffaabbccdd"
RES=`$EXE aka $identity $ck $ik `
OK=""
for p in $RES
do
  checkIfExist $p MK=C91E9668CB030850D5CD8F8483F44AE6A8C9E462
  checkIfExist $p KENCR=9947AD285672BC672B4534FC7C2E5F77
  checkIfExist $p KAUT=30159836B1CF1FD8146F8F95862AC517
  checkIfExist $p MSK=A032291ED31115BBE7D02F11A98198D7B04F4821A8846BE96A92A32888F9AF7E866D3FBF35B3E18CA097EF66CD78CF489B678C6167003E7BBA2E2CA7B8ADD50E
  checkIfExist $p EMSK=F8AB64804BCF215283D6D4EB282A1E3E295E21E9F0FBBE031AC1EB5EF61D18761C6675C320B03D572BB65D42152900351F2A11D480F9CDC24E41DB5509DDE18E
done
checkResult "AKA" $OK "XXXXX"

##############################
# AKA' Calculation
##############################
identity="60111122223333456@wlan.mnc111.mcc222.3gppnetwork.org"
ck="0x12345678901234567890123456789012"
ik="0xaabbccddeeffaabbccddeeffaabbccdd"
RES=`$EXE akaprime $identity $ck $ik `
OK=""
for p in $RES
do
  checkIfExist $p KENCR=C63266BBD9C1778B94B8F2AB3A03B51B
  checkIfExist $p KAUT=D217E5733C2EEEBCCCFAF54BA7B62D6781D1EFF68D8B7D850F3851503BA53684
  checkIfExist $p KRE=3E39D54ED00C4830D8CFD2DF3ABEF8EC4932D11D9A0FDCE4B1813D827307E712
  checkIfExist $p MSK=7C54919E2725C2F7D118AD27FF3E16B7F2AE4BE56F52AAFEE591DDBBDB2A5126C7A899F413EAF608770646564D1443FAF8454663AD868FE6F6E642BD0DBFE624
  checkIfExist $p EMSK=12225B75448A909D3231553FE3A8E6777AA29E55A6E418167B8483ED6FB898154345A4D8F1745641039111ADDB2173B45057012B5E742118CFD8B1DE7ABEF248
done
checkResult "AKA'" $OK "XXXXX"

##############################
# MAC-SIM2 Calculation
##############################
msg="0x010100441701000001050000ce9e2d867cc86dde4cc87899136184d5020500001122334455668001aabbccddeeff99770B05000000000000000000000000000000000000"
K="0x146EF214DFEFBC6BF59D002C0300F95D"
#set -x
RES=`$EXE mac-sim $K $msg`
#set +x
OK=""
for p in $RES
do
  checkIfExist $p MAC=C7D90F86D0F9096989C0334A733952F9
done
checkResult "MAC-SIM2" $OK "X"

##############################
# MAC-SIM3 Calculation
##############################
msg="0x010100441701000001050000ce9e2d867cc86dde4cc87899136184d5020500001122334455668001aabbccddeeff99770B05000000000000000000000000000000000000"
K="0x146EF214DFEFBC6BF59D002C0300F95D"
E="0x3333333333333333FFFFFFFFFFFFFFFF"
#set -x
RES=`$EXE mac-sim $K $msg $E`
#set +x
OK=""
for p in $RES
do
  checkIfExist $p MAC=78F2FD7A52D6E07146307E684B4B9AAB
done
checkResult "MAC-SIM3" $OK "X"

##############################
# MAC-AKA2 Calculation
##############################
msg="0x010100441701000001050000ce9e2d867cc86dde4cc87899136184d5020500001122334455668001aabbccddeeff99770B05000000000000000000000000000000000000"
K="0x146EF214DFEFBC6BF59D002C0300F95D"
#set -x
RES=`$EXE mac-aka $K $msg `
#set +x
OK=""
for p in $RES
do
  checkIfExist $p MAC=C7D90F86D0F9096989C0334A733952F9
done
checkResult "MAC-AKA2" $OK "X"

##############################
# MAC-AKA3 Calculation
##############################
msg="0x010100441701000001050000ce9e2d867cc86dde4cc87899136184d5020500001122334455668001aabbccddeeff99770B05000000000000000000000000000000000000"
K="0x146EF214DFEFBC6BF59D002C0300F95D"
E="0x3333333333333333FFFFFFFFFFFFFFFF"
#set -x
RES=`$EXE mac-aka $K $msg $E`
#set +x
OK=""
for p in $RES
do
  checkIfExist $p MAC=78F2FD7A52D6E07146307E684B4B9AAB
done
checkResult "MAC-AKA3" $OK "X"

##############################
# MAC-AKAPRIME Calculation
##############################
msg="0x010100443201000001050000ce9e2d867cc86dde4cc87899136184d5020500001122334455668001aabbccddeeff99770B05000000000000000000000000000000000000"
K="0x6759D0953F781F4CB4BEEF834EFBA07BCFB808D9B9CFE519BE8248D25E513D9C"
#set -x
RES=`$EXE mac-akaprime $K $msg `
#set +x
OK=""
for p in $RES
do
  checkIfExist $p MAC=F83BF724FAC1CA5242419D91EB3CAA82
done
checkResult "MAC-AKAPRIME2" $OK "X"

##############################
# MAC-AKAPRIME3 Calculation
##############################
msg="0x010100443201000001050000ce9e2d867cc86dde4cc87899136184d5020500001122334455668001aabbccddeeff99770B05000000000000000000000000000000000000"
K="0x6759D0953F781F4CB4BEEF834EFBA07BCFB808D9B9CFE519BE8248D25E513D9C"
E="0x3333333333333333FFFFFFFFFFFFFFFF3333333333333333FFFFFFFFFFFFFFFF"
#set -x
RES=`$EXE mac-akaprime $K $msg $E `
#set +x
OK=""
for p in $RES
do
  checkIfExist $p MAC=AD1B1A46EBF1F54D9260D0833BBFDD73
done
checkResult "MAC-AKAPRIME3" $OK "X"

##############################
# computeOPc Calculation
##############################
OP="0x00112233445566778899aabbccddeeff"
K="0x22222222222222222222222222222222"
RES=`$EXE computeOPc $OP $K`
OK=""
for p in $RES
do
  checkIfExist $p OPc=F3C7745CD602CEEBDD3E9E043C6E8E37
done
checkResult "COMPUTEOPC" $OK "X"

##############################
# Milenage-f1 Calculation
##############################
OPc="0xF3C7745CD602CEEBDD3E9E043C6E8E37"
K="0x22222222222222222222222222222222"
RAND="0x1234567890abcdef1234567890abcdef"
SQN="0x123456789012"
AMF="0x1234"
RES=`$EXE milenage-f1 $OPc $K $RAND $SQN $AMF`
OK=""
for p in $RES
do
  checkIfExist $p XMAC=1670922B7C1F9273
  checkIfExist $p MACS=677082FFF7C341F5
done
checkResult "MILENAGE-F1" $OK "XX"

##############################
# Milenage-F2345 Calculation
##############################
OPc="0xF3C7745CD602CEEBDD3E9E043C6E8E37"
K="0x22222222222222222222222222222222"
RAND="0x1234567890abcdef1234567890abcdef"
RES=`$EXE milenage-f2345 $OPc $K $RAND`
OK=""
for p in $RES
do
  checkIfExist $p OPc=F3C7745CD602CEEBDD3E9E043C6E8E37
  checkIfExist $p XRES=BAC370D326BFFF0A
  checkIfExist $p CK=AC6C6347E319356DDBE05D38A1B6577E
  checkIfExist $p IK=EFDD810BA052E69C74544964F01B37C8
  checkIfExist $p AK=B50CC2809A78
  checkIfExist $p AKS=1AB39EE170F9
done
checkResult "MILENAGE-F2345" $OK "XXXXXX"

##############################
#AT_ENCR_DATA calculation
##############################
kencr="0x3BD3EA34272177EF4655F196E3350EBB"
iv="0x52AB55A91E98EF3A55D92B9203A88BE4"
msg="0x850D00303447744C6D493038434359364153615842515A5A716D445A6E684367484A4B6B394A6A707538455A504D6979736B553D060300000000000000000000"
RES=`$EXE encrypt $iv $kencr $msg`
OK=""
for p in $RES
do
  checkIfExist $p ENCRYPTED=5461D3A9C60F07C45B1752EEFD2782117F0789893E260565300060E7B38069AAD30E3AA689CA8B4EB66926D9D48F13A581FE87CBBE8F908CEAAF6FC6E6F619A9
done
checkResult "AES128-ENCODE" $OK "X"

##############################
#AT_ENCR_DATA calculation
##############################
kencr="0x3BD3EA34272177EF4655F196E3350EBB"
iv="0x52AB55A91E98EF3A55D92B9203A88BE4"
msg="0x5461D3A9C60F07C45B1752EEFD2782117F0789893E260565300060E7B38069AAD30E3AA689CA8B4EB66926D9D48F13A581FE87CBBE8F908CEAAF6FC6E6F619A9"
RES=`$EXE decrypt $iv $kencr $msg`
OK=""
for p in $RES
do
  checkIfExist $p DECRYPTED=850D00303447744C6D493038434359364153615842515A5A716D445A6E684367484A4B6B394A6A707538455A504D6979736B553D060300000000000000000000
done
checkResult "AES128-DECODE" $OK "X"

##############################
# MS-CHAPv2 Calculation
##############################
Identity="0x55736572"
Password="0x636c69656e7450617373"
PWHash=0
Auth="0x8DD6816696EC4540CE6B1976D1278A65"
Peer="0xAE2A17083921C7D6EA9C94077FFED29E"
RES=`$EXE mschapv2 $Identity $Password $PWHash $Auth $Peer`
OK=""
for p in $RES
do
  checkIfExist $p NT-Response=749CEA830B945A6E627174045763B0EEEB3A3E7A1E85E7D5
  checkIfExist $p Auth-Response=6FA0AE0AFDE53F7549983D8310B6BC2C9CEEECAF
  checkIfExist $p Master-key=7E4B2684615A70C233A7036970DC0EA5
done
checkResult "MS-CHAPv2" $OK "XXX"

######################################################        
# History
#0.2.5 - May 25 '12 - Calculating EAP-AKA,EAP-AKA'
#0.2.8 - Aug    '12 - SIM calculations added
#0.3.0 - Oct 22 '12 - Value for mac-sim was wrong. Platform automatically recognized
#      - Mar 28 '13 - computeOPc added. encode/decode renamed to encrypt/decrypt
#      - Sep 24 '13 - testing 2/3 params for MAC calculations
#0.3.2 - Oct 14 '13 - MS-CHAPv2 calculations added
