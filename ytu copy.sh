#!/bin/bash
echo "Bandcamp url"
read bcurl
rm -rf cover.jpg
rm -rf *.mp{3,4}
rm -rf h.txt
bandcamp-dl --template="%{track}" $bcurl
echo -en 'ffmpeg -i "concat:' >> h.txt 
for((var=1;var<99;++var)); do
    case $var in
        [1-5])
        sec=1
        ;;
        [6-10])
        sec=2
        ;;
        [11-15])
        sec=3
        ;;
        [16-20])
        sec=4
        ;;
        [21-25])
        sec=5
        ;;
        [26-30])
        sec=6
        ;;
        [31-35])
        sec=7
        ;;
        *)
    esac
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
    fi
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

    case $var in
    5)
    mv -f ~/.youtube-upload-credentials.json cred$sec/.youtube-upload-credentials.json
    ;;
    10)
    mv -f ~/.youtube-upload-credentials.json cred$sec/.youtube-upload-credentials.json
    ;;
    15)
    mv -f ~/.youtube-upload-credentials.json cred$sec/.youtube-upload-credentials.json
    ;;
    20)
    mv -f ~/.youtube-upload-credentials.json cred$sec/.youtube-upload-credentials.json
    ;;
    25)
    mv -f ~/.youtube-upload-credentials.json cred$sec/.youtube-upload-credentials.json
    ;;
    30)
    mv -f ~/.youtube-upload-credentials.json cred$sec/.youtube-upload-credentials.json
    ;;
    35)
    mv -f ~/.youtube-upload-credentials.json cred$sec/.youtube-upload-credentials.json
    ;;
    *)
    esac
done
