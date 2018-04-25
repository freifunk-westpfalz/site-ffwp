#!/bin/sh

if [ $# -eq 0 -o "-h" = "$1" -o "-help" = "$1" -o "--help" = "$1" ]; then
        cat <<EOHELP
Usage: $0 <manifest>
EOHELP
        exit 1
fi

echo "Please enter your key:"
read SECRET

manifest=$1
upper=$(mktemp)
lower=$(mktemp)

awk "BEGIN    { sep=0 }
     /^---\$/ { sep=1; next }
              { if(sep==0) print > \"$upper\";
                else       print > \"$lower\"}" \
    $manifest

echo $SECRET | /usr/bin/ecdsasign $upper >> $lower

cat  $upper  > $manifest
echo ---    >> $manifest
cat  $lower >> $manifest

rm -f $upper $lower





