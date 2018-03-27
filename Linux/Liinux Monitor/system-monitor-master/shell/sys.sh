#!/bin/bash
#https://github.com/splincode/system-monitor
function current-script-dir() {
 local SOURCE="${BASH_SOURCE[0]}";
 local DIR='';
 while [ -h "$SOURCE" ]; do
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )";
  SOURCE="$( readlink "$SOURCE" )";
  [[ ${SOURCE} != /* ]] && SOURCE="$DIR/$SOURCE";
 done;
 echo "$( cd -P "$( dirname "$SOURCE" )" && pwd )";
}

function debug-info() {
    logsDir="tsv";
    dir=$(current-script-dir);
    mkdir -p "$dir/$logsDir/";

    logFile=$1;
    if [ "X$1" == 'X' ]; then
     echo "[INFO] You did not specify the file name with the first arguments";
     logFile=`echo $(hostname).tsv`;
    fi;

    pathLogFile=${dir}/${logsDir}/${logFile};

    rm "$pathLogFile" > /dev/null 2>&1;
    echo "[INFO] create logfile: $pathLogFile";
    echo -ne "=======================\n";

    report="CPU(%)\tRAM(%)\tDISK(%)\n";
    echo -ne ${report} >> "$pathLogFile";

    while read LINE; do
        string=${LINE};
        set -f;
        array=(${string//\s/ });

        report="${array[2]}\t${array[3]}\t${array[4]}\n";
        echo -ne ${report} >> "$pathLogFile";
        debugReport="\r${array[0]} ${array[1]} \t CPU USAGE: ${array[2]}% \t MEMORY USAGE: ${array[3]}% \t DISK USAGE: ${array[4]}%";
        echo -ne ${debugReport};
    done;

}

while true; do
    time=$(date +"%T %d.%m.%Y");
    cpu=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {printf "%3.2f", usage}');
    memory=$(free -m | awk 'NR==2{printf "%3.2f", $3*100/$2 }');
    disk=$(df -h | awk '$NF=="/"{printf "%3.0f", $5}');
    printf "%s %s %s %s \n" "$time" "$cpu" "$memory" "$disk";
    sleep 1s;
done | debug-info "$1";
