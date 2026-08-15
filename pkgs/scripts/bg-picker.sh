bg_dir=$HOME/.local/share/wallpapers

files=`find $bg_dir ! -type "d" ! -name "default"`
filenames=()
for file in $files; do
  filenames+=(`echo $file | rev | cut -d/ -f1 | rev`)
done

new_bg=`printf '%s\n' "${filenames[@]}" | rofi -dmenu`

if test ! -z $new_bg; then
  ln -sf $new_bg $bg_dir/default
  kill -9 $(pgrep swaybg); swaybg -m fill -i $bg_dir/default & disown
fi
