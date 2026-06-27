bg_dir=$HOME/.local/share/backgrounds

files=`find $bg_dir -type f`
filenames=()
for file in $files; do
  filenames+=(`echo $file | rev | cut -d/ -f1 | rev`)
done

new_bg=`printf '%s\n' "${filenames[@]}" | fuzzel -d`

if test ! -z $new_bg; then
  ln -sf $new_bg $bg_dir/default
  kill -9 $(pgrep swaybg); swaybg -m fill -i ~/.local/share/backgrounds/default & disown
fi
