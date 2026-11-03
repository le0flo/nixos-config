bg_dir=$HOME/.local/share/wallpapers
picker_cmd="wmenu"

files=`find $bg_dir ! -type "d" ! -name "default"`
filenames=()
for file in $files; do
  filenames+=(`echo $file | rev | cut -d/ -f1 | rev`)
done
filenames+=("none")

new_bg=`printf '%s\n' "${filenames[@]}" | $picker_cmd`

if [ ! -z $new_bg ]; then
    kill -9 $(pgrep swaybg); 

    if [ ! "$new_bg" = "none" ]; then
        swaybg -m fill -i $bg_dir/$new_bg & disown
    fi
fi
