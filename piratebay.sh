#!/bin/bash
search="$@"
apiurl="https://apibay.org"
json=$(curl -s "${apiurl}/q.php" --data-urlencode "q=${search}")
out=$(echo $json | jq -r '.[] | del(.info_hash,.category,.imdb) | join("|")' | \
    awk -F'|' '{OFS="|";$8=strftime("%D",$8); print NR" | "$0 }' |\
    numfmt --to iec -d '|' --field 7 |\
    column -N '#',Id,Name,Leechers,Seeders,"#files",Size,User,Added,Status -t -o ' | ' -s '|')

while [ "$input" != "q" ]
do
    echo "$out"
    #echo input=$input
    if [[ -n $input ]] && [[ $input =~ [0-9]+ ]]; then
        trackers="&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.to%3A2710%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2780%2Fannounce&tr=udp%3A%2F%2F9.rarbg.to%3A2730%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=http%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.tiny-vps.com%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce"
        infohash=$(echo $json | jq -r '.['$(($input -1))'] | .info_hash+"&dn="+.name')
        #echo magnet_url: magnet:?xt=urn:btih:${infohash}&dn=Sang%20sattawat%20-%20Syndromes%20and%20a%20century%20(2006)&tr=udp%3A%2F%2Ftracker.coppersurfer.tk%3A6969%2Fannounce&tr=udp%3A%2F%2Ftracker.openbittorrent.com%3A6969%2Fannounce&tr=udp%3A%2F%2F9.rarbg.to%3A2710%2Fannounce&tr=udp%3A%2F%2F9.rarbg.me%3A2780%2Fannounce&tr=udp%3A%2F%2F9.rarbg.to%3A2730%2Fannounce&tr=udp%3A%2F%2Ftracker.opentrackr.org%3A1337&tr=http%3A%2F%2Fp4p.arenabg.com%3A1337%2Fannounce&tr=udp%3A%2F%2Ftracker.torrent.eu.org%3A451%2Fannounce&tr=udp%3A%2F%2Ftracker.tiny-vps.com%3A6969%2Fannounce&tr=udp%3A%2F%2Fopen.stealth.si%3A80%2Fannounce
        echo "magnet:?xt=urn:btih:$infohash$trackers"
    fi
    read -p "Enter a torrent # or q to quit: " input
done

