# header  & basic
dd if=/Users/mist/Library/Mobile\ Documents/com\~apple\~CloudDocs/Applications/xscpu64.app/Contents/Resources/ROM/SCPU64/scpu64 of=scpu64 bs=256 count=33

# hi_basic #1
dd if=/Users/mist/Library/Mobile\ Documents/com\~apple\~CloudDocs/Applications/xscpu64.app/Contents/Resources/ROM/SCPU64/scpu64 bs=256 skip=33 count=5 >> scpu64
# kernal #1
dd if=c64-rom.bin bs=256 skip=5 count=27 >> scpu64

# hi_basic #2
dd if=/Users/mist/Library/Mobile\ Documents/com\~apple\~CloudDocs/Applications/xscpu64.app/Contents/Resources/ROM/SCPU64/scpu64 bs=256 skip=33 count=5 >> scpu64
# kernal #2
dd if=c64-rom.bin bs=256 skip=5 count=27 >> scpu64

# rest
dd if=/Users/mist/Library/Mobile\ Documents/com\~apple\~CloudDocs/Applications/xscpu64.app/Contents/Resources/ROM/SCPU64/scpu64 skip=97 bs=256 >> scpu64

# activate
mv scpu64 xscpu64.app/Contents/Resources/ROM/SCPU64