bg_dir=$HOME/.local/share/wallpapers

if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    picker_cmd="wmenu"
else
    picker_cmd="dmenu"
fi

files=`find $bg_dir ! -type "d" ! -name "default"`
filenames=()
for file in $files; do
  filenames+=(`echo $file | rev | cut -d/ -f1 | rev`)
done
filenames+=("none")

new_bg=`printf '%s\n' "${filenames[@]}" | $picker_cmd`

if [ ! -z $new_bg ]; then
    if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        kill -9 $(pgrep swaybg)
    else
        xwallpaper --clear
    fi

    if [ ! "$new_bg" = "none" ]; then
        if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
            swaybg -m center -i $bg_dir/$new_bg & disown
        else
            xwallpaper --center $bg_dir/$new_bg & disown
        fi
    fi
fi
