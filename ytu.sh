#!/bin/bash
echo "Bandcamp url"
read bcurl
rm -rf cover.jpg
rm -rf *.mp{3,4}
rm -rf h.txt
bandcamp-dl --template="%{track}" $bcurl
echo -en 'ffmpeg -i "concat:' >> h.txt 
for((var=1;var<99;++var)); do
    if [[ $var -ge 1 && $var -le 5 ]]; then
        sec=1
    elif [[ $var -ge 6 && $var -le 10 ]]; then
        sec=2
    elif [[ $var -ge 11 && $var -le 15 ]]; then
        sec=3
    elif [[ $var -ge 16 && $var -le 20 ]]; then
        sec=4
    elif [[ $var -ge 21 && $var -le 25 ]]; then
        sec=5
    elif [[ $var -ge 61 && $var -le 30 ]]; then
        sec=6
    elif [[ $var -ge 31 && $var -le 35 ]]; then
        sec=7
    fi
    ffmpeg -loop 1 -i cover.jpg -i $(printf %02d $var).mp3 -c:v libx264 -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p -shortest $(printf %02d $var).mp4
    artist=`mediainfo --Inform='General;%Artist%'  $(printf %02d $var).mp3`
    track=`mediainfo --Inform='General;%Title%' $(printf %02d $var).mp3`
    album=`mediainfo --Inform='General;%Album%' $(printf %02d $var).mp3`
    cp -f cred$sec/.youtube-upload-credentials.json ~/.youtube-upload-credentials.json
    youtube-upload --title="$artist - $track" --description="From the album $album $bcurl" --playlist="$artist - $album" --client-secrets="client_secrets_$sec.json" $(printf %02d $var).mp4
    sleep 5
    if [ -e  $(printf %02d $var).mp4 ]; then
        echo -en "$(printf %02d $var).mp3|" >> h.txt
    else
    artist=`mediainfo --Inform='General;%Artist%' 01.mp3`
    album=`mediainfo --Inform='General;%Album%'  01.mp3`
    echo -en '" -c copy all.mp3' >> h.txt
    i=`cat h.txt`
    eval $i
    ffmpeg -loop 1 -i cover.jpg -i all.mp3 -c:v libx264 -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p -shortest all.mp4
    youtube-upload --title="$artist - $album [Full Album]" --description="$bcurl" --client-secrets="client_secrets_$sec.json" all.mp4
	rm -rf *.mp3
	rm -rf *.mp4
    rm -rf h.txt
    var=99
	rm -rf cover.jpg
    fi
    if [ $var -eq 5 ]; then 
        mv -f ~/.youtube-upload-credentials.json cred$sec/.youtube-upload-credentials.json
    elif [ $var -eq 10 ]; then 
        mv -f ~/.youtube-upload-credentials.json cred$sec/.youtube-upload-credentials.json
    elif [ $var -eq 15 ]; then 
        mv -f ~/.youtube-upload-credentials.json cred$sec/.youtube-upload-credentials.json
    elif [ $var -eq 20 ]; then
        mv -f ~/.youtube-upload-credentials.json cred$sec/.youtube-upload-credentials.json
    elif [ $var -eq 25 ]; then  
        mv -f ~/.youtube-upload-credentials.json cred$sec/.youtube-upload-credentials.json
    elif [ $var -eq 30 ]; then  
        mv -f ~/.youtube-upload-credentials.json cred$sec/.youtube-upload-credentials.json
    elif [ $var -eq 35 ]; then  
        mv -f ~/.youtube-upload-credentials.json cred$sec/.youtube-upload-credentials.json
    fi
done
