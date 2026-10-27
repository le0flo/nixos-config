mode=$1

if [ "$mode" = "area" ]; then
    rectangle=`slurp -w 2`

    if [ -z "$rectangle" ]; then
        notify-send "Screenshot cancelled"
        exit 1
    fi

    grim -c -g "$rectangle" - | tee ~/Pictures/Screenshots/screenshot-$(date +%Y-%m-%d-%H%M%S).png | wl-copy -t image/png && notify-send "Screenshot saved"
    exit 0
elif [ "$mode" = "screen" ]; then
    grim -c - | tee ~/Pictures/Screenshots/screenshot-$(date +%Y-%m-%d-%H%M%S).png | wl-copy -t image/png && notify-send "Screenshot saved"
    exit 0
else
    echo "Unknown mode"
    exit 1
fi
