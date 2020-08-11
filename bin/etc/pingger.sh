#Pingger Stable
#by wahyu6070
sleep 30s
app_list(){
	pm list packages | grep $1
	}
if [ $(app_list org.lineageos.updater) ]; then 
pm disable org.lineageos.updater
fi

if [ $(app_list com.aospextended.ota) ]; then 
pm disable com.aospextended.ota
fi

