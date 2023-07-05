# shellcheck shell=bash

function convert_to_bytes() {
    unit=${1:-1}  
    unit=${unit^^}   

    if [[ $unit =~ ([0-9]+\.)?[0-9]+B ]]; then 
        multiplier=1
    elif [[ $unit =~ ([0-9]+\.)?[0-9]+K ]]; then
        multiplier=1000 
    elif [[ $unit =~ ([0-9]+\.)?[0-9]+M ]]; then
        multiplier=1000000 
    elif [[ $unit =~ ([0-9]+\.)?[0-9]+G ]]; then
        multiplier=1000000000 
    elif [[ $unit =~ ([0-9]+\.)?[0-9]+T ]]; then
        multiplier=1000000000000
    fi

    amount=${unit%?}
    amount=$(echo "scale=0; $amount * $multiplier" | bc) 
    amount=${amount%.*}
    echo "$amount"
}

function bytes_to_unit() {
    bytes=$1

    if [[ $bytes -lt 1000 ]]; then
        echo "${bytes}B"
        return
    elif [[ $bytes -lt 1000000 ]]; then
        unit=KB
        multiplier=1000
    elif [[ $bytes -lt 1000000000 ]]; then
        unit=MB
        multiplier=1000000
    elif [[ $bytes -lt 1000000000000 ]]; then
        unit=GB
        multiplier=1000000000
    else 
        unit=TB
        multiplier=1000000000000
    fi

    amount=$((bytes / multiplier))
    echo "${amount}${unit}"
}

DATASET_NAME="$1"
POOL=$(echo "$DATASET_NAME" | sed -r 's/\/[a-z]+$//')

POOL_TOTAL=$(zpool list "$POOL" -o size | sed -e 's/SIZE//' | tr -d \[:space:\])

DATASET_USED=$(zfs list -o used "$DATASET_NAME" | sed -e 's/USED//' | tr -d \[:space:\])
DATASET_AVAILABLE=$(zfs list -o avail "$DATASET_NAME" | sed -e 's/AVAIL//' | tr -d \[:space:\])

DATASET_USED_BYTES=$(convert_to_bytes "$DATASET_USED")
DATASET_AVAILABLE_BYTES=$(convert_to_bytes "$DATASET_AVAILABLE")

DATASET_TOTAL_BYTES=$((DATASET_USED_BYTES + DATASET_AVAILABLE_BYTES))
DATASET_TOTAL=$(bytes_to_unit "$DATASET_TOTAL_BYTES")

COMPRESS_RATIO=$(zfs list -o compressratio "$DATASET_NAME" | tr -d 'RATIO\n ' | tr -d \[:space:\])

echo "$DATASET_NAME $DATASET_USED/$DATASET_TOTAL ($POOL_TOTAL) ($COMPRESS_RATIO)"