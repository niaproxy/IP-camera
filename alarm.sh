#!/bin/bash 

st_dir=/home/ivan/camera/
ip="192.168.5.219"

function check_folder {
	item_count=$(ls $st_dir | grep avi | wc -l)
	if [ $item_count > 300 ]; then
		find $st_dir -name *.avi -ctime 7 -delete
		fi
	if [ $item_count > 300 ]; then
		find $st_dir -name *.avi -cmin 30 -delete
		fi

}


function alarm_input() {
	trigger=$(netcat -l 15002 |  wc -l) 
}



function record_video {
	if [ $trigger == 1  ]; then
		ffmpeg -i "rtsp://$ip:554/user=admin&password=&channel=0&stream=0.sdp?real_stream--rtp-caching=100" -c copy -t 60 $st_dir$(date -Im).avi
		fi
}

function get_image {
	if [ $trigger == 1  ]; then
		ffmpeg -i "rtsp://$ip:554/user=admin&password=&channel=0&stream=0.sdp?real_stream--rtp-caching=100" -r 1 $st_dir$(date -Is).jpg
		fi
}

function alarm_output_sms {
	chat -v "" 'AT+CMGF=1' "OK" > /dev/ttyACM1 < /dev/ttyACM1
	chat -v "" 'AT+CMGS="+79198343627"' ">" > /dev/ttyACM1 < /dev/ttyACM1
	chat -v "" 'Зафиксировано движение на камере №1^Z' "OK" > /dev/ttyACM1 < /dev/ttyACM1		
}

function alarm_output_mail {
	curr_time=$(date -Im)
	get_image $curr_time
	echo "Подозрительный обьект замечен на территории" | mutt -s "Зафиксированно вторжение" -a "$st_dir$curr_time.jpg" someone@example.com
}

while true ; do
alarm_input
#check_folder && record_video
get_image
done
