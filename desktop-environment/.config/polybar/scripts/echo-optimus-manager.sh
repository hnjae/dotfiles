#!/usr/bin/dash

curMode=`optimus-manager --print-mode`
case $curMode in
	"Current GPU mode : integrated")
		echo 'integrated'
		#  nf-mdi-google_circles  
		# ﮞ
		# 

		;;
	"Current GPU mode : hybrid")
		echo 'hybrid'
		;;
	"Current GPU mode : nvidia")
		;;
	*)
		;;
esac
# if [ curMode =  ]; then
# 	echo 'integrated'
# elif [ curMode  ]
