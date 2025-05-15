#!/bin/bash
echo performance > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo 1416000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 1 > /sys/devices/system/cpu/cpu0/online
echo 1 > /sys/devices/system/cpu/cpu1/online
echo 1 > /sys/devices/system/cpu/cpu2/online
echo 1 > /sys/devices/system/cpu/cpu3/online

port="$1"

sed -i -e '/^XDG_DATA_HOME=\${XDG_DATA_HOME:-\$HOME\/.local\/share}/ {' \
-e 'i\export HOME="/mnt/SDCARD/Roms/PORTS"' \
-e 's|\XDG_DATA_HOME=\${XDG_DATA_HOME:-\$HOME/.local/share}|\export XDG_DATA_HOME=\${XDG_DATA_HOME:-\$HOME/.local/share}|' \
-e '}' "$port"

sed -i '
/^if \[ -d "\/opt\/system\/Tools\/PortMaster\/" \]; then/,/^fi/ c\
export controlfolder="/mnt/SDCARD/Roms/PORTS/PortMaster"
' "$port"

sed -i '
/^if \[\[ \$CFW_NAME == "TheRA" \]\]; then/,/^fi/ c\
raloc="/mnt/SDCARD/RetroArch"\
reconf="/mnt/SDCARD/RetroArch/.config/retroarch/retroarch.cfg"\
export HOME="/mnt/SDCARD/RetroArch"
' "$port"

sed -i 's|\$raloc/retroarch\([[:space:]]\)|\$raloc/retroarch.flip\1|' "$port"

sed -i 's|/\$directory/ports/|\$directory/|g' "$port"
sed -i 's|/\$directory/ports|\$directory/|g' "$port"

sync

export HOME="/mnt/SDCARD/Roms/PORTS"
export PATH="/mnt/SDCARD/miyoo355/bin:${PATH}"
export LD_LIBRARY_PATH="/mnt/SDCARD/App/PortMaster/lib:/mnt/SDCARD/miyoo355/lib:${LD_LIBRARY_PATH}"
export controlfolder="/mnt/SDCARD/Roms/PORTS/PortMaster"
export directory="/mnt/SDCARD/Roms/PORTS"
export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}

cd "${directory}" && ./"$(basename "$port")"
sync

pkill -9 gptokeyb2
pkill -9 gptokeyb
pkill -9 oga_controls

echo ondemand > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo 1008000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
echo 1 > /sys/devices/system/cpu/cpu0/online
echo 1 > /sys/devices/system/cpu/cpu1/online
echo 0 > /sys/devices/system/cpu/cpu2/online
echo 0 > /sys/devices/system/cpu/cpu3/online

unset HOME
unset controlfolder
unset directory
unset XDG_DATA_HOME
unset PATH
unset LD_LIBRARY_PATH