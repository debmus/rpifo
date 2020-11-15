#!/bin/bash

# Nom d'hôte
show_hote=$(hostname)
# Adresse IP
show_ip=$(ip a show eth0 | awk 'NR == 3 {print substr($2,1, length($2)-3)}')
# Distribution
show_os=$(echo "$(lsb_release -d | awk '{$1="";print}') - ($(cat /etc/debian_version))" | sed -e '1s/^.//')
# Version kernel
show_kernel=$(uname -srm)
# Température
show_temp=$(vcgencmd measure_temp | egrep -o '[0-9]*\.[0-9]*')
# Temps d'utilisation
show_uptime=$(uptime -p | sed 's/up //g; s/hours/Heures/g; s/days/Jours/g; s/weeks/Semaines/g; s/month/Mois/g')
# Charge CPU
show_loadaverage=$(cat /proc/loadavg)
show_loadaverage1=$(echo $show_loadaverage | awk '{print $1}')
show_loadaverage2=$(echo $show_loadaverage | awk '{print $2}')
show_loadaverage3=$(echo $show_loadaverage | awk '{print $3}')
# Disque SD
exec_df=$(df)
exec_df_H=$(df -h)
show_sd_total=$(echo "$exec_df" | awk '/root/ {print $2}')
show_sd_used=$(echo "$exec_df" | awk '/root/ {print $3}')
show_sd_total_H=$(echo "$exec_df_H" | awk '/root/ {print $2}')
show_sd_used_H=$(echo "$exec_df_H" | awk '/root/ {print $3}')

# Mémoire + Swap
exec_free=$(free --kilo)
exec_free_H=$(free --kilo -h)
# Mémoire
show_mem_total=$(echo "$exec_free" | awk '/Mem:/ {print $2}')
show_mem_used=$(echo "$exec_free" | awk '/Mem/ {print $3}')
show_mem_total_H=$(echo "$exec_free_H" | awk '/Mem:/ {print $2}')
show_mem_used_H=$(echo "$exec_free_H" | awk '/Mem/ {print $3}')

# Swap
show_swap_total=$(echo "$exec_free" | awk '/Swap:/ {print $2}')
show_swap_used=$(echo "$exec_free" | awk '/Swap/ {print $3}')
show_swap_total_H=$(echo "$exec_free_H" | awk '/Swap:/ {print $2}')
show_swap_used_H=$(echo "$exec_free_H" | awk '/Swap/ {print $3}')

echo "{
    \"hote\": \"$show_hote\",
    \"temp\": \"$show_temp\",
    \"info\": [
        {
            \"title\": \"Adresse IP\",
            \"response\": \"$show_ip\"
        },
        {
            \"title\": \"Distribution\",
            \"response\": \"$show_os\"
        },
        {
            \"title\": \"Version du noyau\",
            \"response\": \"$show_kernel\"
        },
        {
            \"title\": \"Temps d'utilisation\",
            \"response\": \"$show_uptime\"
        }
    ],
    \"cpu\": [
        {
            \"title\": \"$show_loadaverage1\"
        },
        {
            \"title\": \"$show_loadaverage2\"
        },
        {
            \"title\": \"$show_loadaverage3\"
        }
    ],
    \"mem\": [
        {
            \"total\": \"$show_mem_total\",
            \"use\": \"$show_mem_used\",
            \"totalH\": \"$show_mem_total_H\",
            \"useH\": \"$show_mem_used_H\"
        }
    ],
    \"swap\": [
        {
            \"total\": \"$show_swap_total\",
            \"use\": \"$show_swap_used\",
            \"totalH\": \"$show_swap_total_H\",
            \"useH\": \"$show_swap_used_H\"
        }
    ],
    \"sd\": [
        {
            \"total\": \"$show_sd_total\",
            \"use\": \"$show_sd_used\",
            \"totalH\": \"$show_sd_total_H\",
            \"useH\": \"$show_sd_used_H\"
        }
    ]
}" >/var/www/rpifo/result.json