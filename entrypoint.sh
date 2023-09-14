#!/bin/bash

root_path="/anarki/apps/news"

check_and_make() {
    path="$root_path/$1"

    if [ ! -e $path ]; then
        mkdir -p $path
    fi
}

check_and_copy() {
    dst="$root_path/$1"
    src="$root_path/$2"

    if [ ! -e $dst ]; then
        cp -r $src $dst
    fi

    for f in $(find $src -type f); do
        n=$(basename $f)

        if [ ! -e "$dst/$n" ]; then
            cp $f $dst
        fi
    done
}

replace_news_color() {
    hex=$1
    r=$((16#${hex:0:2}))
    g=$((16#${hex:2:2}))
    b=$((16#${hex:4:2}))

    sed -i "s|(color 180 180 180)|(color $r $g $b)|g" $root_path/news.arc
}

replace_args() {
    sed -i "s|arc.sh -i|arc.sh $1|g" $root_path/run-news
}

replace_news() {
    sed -i "s|[\"]$1[\"]|\"$2\"|g" $root_path/news.arc
}

if [ ! -e "$root_path/init" ]; then
    echo "initializing news.arc..."

    # Init dirs
    check_and_make "www/logs"
    check_and_make "www/page"
    check_and_make "www/profile"
    check_and_make "www/story"
    check_and_make "www/vote"
    check_and_make "www/tmp"
    check_and_copy "static" "static-copy"

    # Set up admin
    echo $SITE_ADMIN > $root_path/www/admins

    replace_news "Anarki" $SITE_NAME
    replace_news "http://site.example.com" $SITE_URL
    replace_news "http://github.com/arclanguage/anarki" $PARENT_URL
    replace_news "What this site is about." $SITE_DESC
    replace_news "arc.png" $SITE_LOGO
    replace_news_color $SITE_COLOR

    date > $root_path/init
fi

cd $root_path && nohup ./run-news