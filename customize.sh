# pingger stable
# By wahyu6070

#kopi functions
. $MODPATH/bin/kopi

#pingger path
pingger=/data/media/0/pingger
data=$pingger/data
profile=$pingger/Pingger.profile
tmp=/data/adb/pingger
files=$tmp/bin/files
etc=$tmp/bin/etc
log=$pingger/Pingger.log
prop=$MODPATH/system.prop
rm -rf $log
serviced=/data/adb/service.d/pingger.sh
unset system
system=/sbin/.magisk/mirror/system
unset vendor
vendor=/sbin/.magisk/mirror/vendor
upinfo (){ grep_prop $1 $tmp/module.prop; }
sedlog (){ echo "    [Prossesing] ===> $1" >> $log; }
unset getp
getp(){ grep_prop "$1" $profile; }

[ "$(getp username)" ] && username="$(getp username)" || username="Not Set"

debloat(){
	for findep in $system/priv-app $system/app $system/product/priv-app $system/product/app
	do
	unset debloatdir
	  if [ -d $findep/$1 ]; then
	  debloatdir=$findep/$1
      break
	  fi
	  done
	  if [ $debloatdir ]; then
	  sedlog "Debloating $1..."
	  [ $(echo "$debloatdir" | grep product) ] && dir123=$MODPATH/system/product || dir123=$MODPATH/system
	  [ $(echo "$debloatdir" | grep priv-app) ] && newdebloat=$dir123/priv-app || newdebloat=$dir123/app
	  mkdir -p $newdebloat/$1 || sedlog "Failed Chreating Folder $newdebloat/$1"
	  sedlog "Debloating directory $debloatdir"
	  touch $newdebloat/$1/$1.apk || sedlog "Failed Chreating File $newdebloat/$1"
	  echo "#Pingger Debloat" > $newdebloat/$1/$1.apk
	  else
	  sedlog "Debloating $1 Not found"
	  fi
}

printlog "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
printlog "▒ Name            : $MODULENAME"
printlog "▒ Version         : $MODULEVERSION"
printlog "▒ Build date      : $MODULEDATE"
printlog "▒ By              : $MODULEAUTHOR"
printlog "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
if [ $(getp Credit) = ON ]; then
print "▒"
print "▒ Telegram Group  : https://t.me/wahyu6070group"
print "▒ Youtube         : www.youtube.com/c/wahyu6070"
fi
printlog "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
printlog "▒              Device Info"
printlog "▒ Name Rom        : $ANDROIDROM"
printlog "▒ Android Version : $ANDROIDVERSION"
printlog "▒ Kernel          : $kernel"
printlog "▒ Date Install    : $(date '+%d/%m/%Y %H:%M:%S')"
printlog "▒ Username        : $username"
printlog "▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒"
printlog " "

#Check new version
if [ $internet = online ]; then
rm -rf $tmp/module.prop
rm -rf $tmp/changelog
wget -O $tmp/module.prop https://raw.githubusercontent.com/Wahyu6070/Pingger-Stable-For-Game/master/module.prop >&2
sleep 1s
   if [ $(upinfo versionCode) -gt $MODULECODE ]; then
   printlog "----> New Version Anvailable <------"
   printlog "Version = $(upinfo version)"
   printlog "Date    = $(upinfo date)"
   wget -O $tmp/changelog https://raw.githubusercontent.com/Wahyu6070/Pingger-Stable-For-Game/master/changelog >&2
   cat $tmp/changelog
   printlog " "
   fi
fi   


#extrack files
[ -d $tmp/bin ] && del $tmp/bin
cdir $tmp $pingger
[ ! -d $data ] && cdir $data
unzip -o "$ZIPFILE" 'bin/*' -d $tmp >&2


#profile
if [ ! -f  $profile ]; then
cp -pf $etc/Pingger.profile $pingger
elif [[ $(getp pingger.code) != $MODULECODE ]]; then
cp -pf $etc/Pingger.profile $pingger
fi

#document
if [ ! -f $pingger/Documents.txt ]; then
cp -pf $etc/Documents.txt $pingger/
elif [[ $(grep_prop pinggerdocversion $pingger/Documents.txt) != $(grep_prop pinggerdocversion $etc/Documents.txt) ]]; then
cp -pf $etc/Documents.txt $pingger/
fi

test ! -f $data/gaming_mode_3_list && cp -pf $etc/gaming_mode_3_list $data/ && sedlog "copying gaming mode 3 list"

# service.d
test ! -d /data/adb/service.d && cdir /data/adb/service.d && sedlog "Creating folder /data/adb/service.d"
touch $serviced
echo "#!/system/bin/sh" > $serviced
chmod 777 $serviced

# apn
cdir $MODPATH/system/etc
if [ $(getp Ping1) = ON ]; then
printlog "- Installing APN V1"
cp -pf $files/apn1 $MODPATH/system/etc/apns-conf.xml
elif [ $(getp Ping2) = ON ]; then
printlog "- Installing APN V2"
cp -pf $files/apn2 $MODPATH/system/etc/apns-conf.xml
elif [ $(getp Ping3) = ON ]; then
printlog "- Installing APN V3"
cp -pf $files/apn3 $MODPATH/system/etc/apns-conf.xml
elif [ $(getp Ping4) = ON ]; then
printlog "- Installing APN V4"
cp -pf $files/apn4 $MODPATH/system/etc/apns-conf.xml
elif [ $(getp Ping5) = ON ]; then
printlog "- Installing APN V5"
cp -pf $files/apn5 $MODPATH/system/etc/apns-conf.xml
elif [ $(getp Ping6) = ON ]; then
printlog "- Installing APN V6"
cp -pf $files/apn6 $MODPATH/system/etc/apns-conf.xml
fi
sleep 1s

#Features

printlog "- Installing Pingger control in system"
mkdir -p $MODPATH/system/bin
cp -pf $MODPATH/bin/etc/pingger $MODPATH/system/bin/

if [ -d /data/data/com.termux ]; then
printlog "- Termux detected"
printlog "- Installing Pingger control in Termux"
cp -pf $MODPATH/bin/etc/pingger /data/data/com.termux/files/usr/bin/
chmod 775 /data/data/com.termux/files/usr/bin/pingger
sleep 1s
fi

#magiskboot
if [ -f /data/adb/magisk/magiskboot ]; then
sedlog "Copying magiskboot in xbin"
mkdir -p $MODPATH/system/xbin
cp -pf /data/adb/magisk/magiskboot $MODPATH/system/xbin/
chmod 775 $MODPATH/system/xbin/magiskboot
fi


if [ $(getp GmsDose) = ON ]; then
printlog "- Installing Universal GMS dose by gloeyisk"
cp -pf $files/gms.sh /data/adb/service.d/
chmod 777 /data/adb/service.d/gms.sh
mkdir -p $MODPATH/system/etc/sysconfig
cp -pf $files/google.xml $MODPATH/system/etc/sysconfig
fi
sleep 1s

if [ $(getp Permissive) = ON ]; then
printlog "- Set Selinux Permissive"
echo "setenforce 0" >> $serviced
sleep 1s
fi

if [ $(getp HSPA) = ON ]; then
printlog "- 3G/HSPA+ signal + speed"
cat $tmp/bin/etc/tweaks/3g >> $prop
sleep 1s
fi

if [[ $(getp Camera2api) == ON ]]; then
printlog "- Enable Camera2api"
echo "persist.camera.HAL3.enabled=1" >> $prop
echo "persist.vendor.camera.HAL3.enabled=1" >> $prop
echo "persist.camera.eis.enable=1" >> $prop
sleep 1s
fi


if [[ $(getp Logs) == ON ]]; then
printlog "- Disable Logs"
cat $tmp/bin/etc/tweaks/logs >> $prop
sleep 1s
fi

if [[ $(getp DisableThermal) == ON ]]; then
printlog "- Disable Thermal Engine"
cdir $MODPATH/system/vendor/etc
touch $MODPATH/system/vendor/etc/thermal-engine.conf
sedlog "Disabling vendor thermal-engine.conf"
cdir $MODPATH/system/vendor/bin
touch $MODPATH/system/vendor/bin/thermal-engine
sedlog "Disabling vendor bin thermal-engine"
    if [ -f /vendor/lib/hw/thermal.sdm660.so ]; then
    sedlog "Disabling thermal sdm660 lib"
    cdir $MODPATH/system/vendor/lib/hw
    touch $MODPATH/system/vendor/lib/hw/thermal.sdm660.so
    fi
    if [ -f /vendor/lib/hw/thermal.sdm660.so ]; then
    sedlog "Disabling thermal sdm660 lib64"
    cdir $MODPATH/system/vendor/lib64/hw
    touch $MODPATH/system/vendor/lib64/hw/thermal.sdm660.so
    fi

sleep 1s
fi

if [[ $(getp DisableUpdater) == ON ]]; then
printlog "- Disable Ota Updater"
cat $MODPATH/bin/etc/pingger.sh >> $serviced
#Updater asus stock
debloat DMClient
debloat Updater
sleep 1s
fi

if [ $(getp ErrorChecking) = ON ]; then
printlog "- Disabling Error Checking"
cat $tmp/bin/etc/tweaks/disable_error_checking >> $prop
sleep 1s
fi

if [ $(getp Volwifi) = ON ]; then
printlog "- Enable Vowifi And Volte"
cat $tmp/bin/etc/tweaks/volte_vowifi >> $prop
sleep 1s
fi

if [ $(getp ScrollingImprovement) = ON ]; then
printlog "- Improvement Scrolling"
cat $tmp/bin/etc/tweaks/improvement_scrolling >> $prop
sleep 1s
fi

if [ $(getp TouchSceenImprovement) = ON ]; then
printlog "- Improvement Touch"
cat $tmp/bin/etc/tweaks/touch_improvement >> $prop
sleep 1s
fi

if [ $(getp PersistantNotif) = ON ]; then
printlog "- Disable Persistant Notification"
cat $tmp/bin/etc/tweaks/disable_persistant_notications >> $prop
sleep 1s
fi

case $(uname -r) in
*Raging*)
printlog "- Trb Kernel detected,fixed vendor nofication "
echo "ro.treble.enabled=false" >> $prop ;;
*Beast*)
printlog "- Trb Kernel detected,fixed vendor nofication "
echo "ro.treble.enabled=false" >> $prop ;;
*Kamisama*)
printlog "- Kamisama Kernel detected,fixed vendor nofication "
echo "ro.treble.enabled=false" >> $prop;;
esac

fake=$(getp FakeBattery)
if [ $fake -eq $fake ]; then
printlog "- Set Fake Battery $fake%"
echo "echo $fake > /sys/class/power_supply/battery/capacity" >> $serviced
sleep 1s
fi

#wifi bonding by simonsmh
if [ $(getp WifiBonding) = ON ]; then
printlog "- Wifi Bonding enable "
findcfg=$(find /system /vendor -name WCNSS_qcom_cfg.ini)
for i in $findcfg
do
[[ -f $i ]] && [[ ! -L $i ]] && {
path=$i
mkdir -p `dirname $MODPATH$i`
[[ -f /sbin/.magisk/mirror$i ]] && cp -af /sbin/.magisk/mirror$path $MODPATH$path || cp -af $path $path
sedlog "- Wifi bonding enabled"
sed -i '/gChannelBondingMode24GHz=/d;/gChannelBondingMode5GHz=/d;/gForce1x1Exception=/d;s/^END$/gChannelBondingMode24GHz=1\ngChannelBondingMode5GHz=1\ngForce1x1Exception=0\nEND/g' $MODPATH$path
}
done
fi

if [ $(getp SmoothStreaming) = ON ]; then
printlog "- Smooth Streaming"
echo "mm.enable.smoothstreaming=true" >> $prop
sleep 1s
fi

if [ $(getp Dt2w) = ON ]; then
printlog "- Enabling DT2W"
echo "echo 1 > /sys/kernel/touchpanel/dclicknode" >> $serviced
sleep 1s
fi

if [ $(getp DebloatingGapps) = ON ]; then
printlog "- Debloating Google Apps"
debloat Gmail2
debloat YandexApp
debloat Velvet
debloat YandexBrowser
debloat Photos
debloat Duo
debloat Drive
debloat Babe
debloat Shopee
debloat Maps
debloat Music2
fi


if [ -f $pingger/bootanimation.zip ]; then
printlog "- Bootanimation.zip detected installing"
	if [ -f $system/media/bootanimation.zip ]; then
	    mkdir -p $MODPATH/system/media
	    sedlog "Using /system/media/bootanimation.zip"
		cp -pf $pingger/bootanimation.zip $MODPATH/system/media/
	elif [ -f $system/product/media/bootanimation.zip ]; then
	    mkdir -p $MODPATH/system/product/media
	    sedlog "Using /system/product/media/bootanimation.zip"
		cp -pf $pingger/bootanimation.zip $MODPATH/system/product/media/
	else
		sedlog "Bootanimation.zip Media not support"
	fi
sleep 1s
fi

#add uninstall.sh script
sedlog "Added uninstalling script"
echo "rm -rf /data/media/0/pingger" > $MODPATH/uninstall.sh
echo "rm -rf /data/adb/pingger" >> $MODPATH/uninstall.sh
echo "rm -rf /data/adb/service.d/pingger.sh" >> $MODPATH/uninstall.sh
echo "rm -rf /data/adb/service.d/gms.sh" >> $MODPATH/uninstall.sh
echo "rm -rf /data/data/com.termux/files/usr/bin/pingger" >> $MODPATH/uninstall.sh
echo " " >> $MODPATH/uninstall.sh

printlog "- Cleaning cache"
del $tmp
del $MODPATH/bin

ui_print " "
ui_print "*tips"
ui_print "- open terminal"
ui_print "- su (enter)"
ui_print "- pingger (enter)"
ui_print " "
ui_print "- Edit /sdcard/pingger/Pingger.profile for Disable/enable features"
ui_print " "

# Default permissions
set_perm $MODPATH/system/bin/pingger 0 0 0775 0777
set_perm /data/adb/service.d/pingger.sh 0 0 0775 0777
