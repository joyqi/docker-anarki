#!/bin/bash

root_path="/anarki"
app_path="$root_path/apps/news"

check_and_make() {
    path="$app_path/$1"

    if [ ! -e $path ]; then
        mkdir -p $path
    fi
}

check_and_copy() {
    dst="$app_path/$1"
    src="$app_path/$2"

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

    sed -i "s|(color 180 180 180)|(color $r $g $b)|g" $app_path/news.arc
}

replace_args() {
    sed -i "s|arc.sh -i|arc.sh $1|g" $app_path/run-news
}

replace_news() {
    sed -i "s|[\"]$1[\"]|\"$2\"|g" $app_path/news.arc
}

config_smtp() {
    echo "$SMTP_USER|$SMTP_HOST:$SMTP_PASS" > /etc/dma/auth.conf

    echo "SMARTHOST $SMTP_HOST" > /etc/dma/dma.conf
    echo "PORT $SMTP_PORT" >> /etc/dma/dma.conf
    echo "AUTHPATH /etc/dma/auth.conf" >> /etc/dma/dma.conf
    echo "MASQUERADE $SMTP_FROM" >> /etc/dma/dma.conf

    if [ "$SMTP_TLS" = "true" ]; then
        echo "SECURETRANSFER" >> /etc/dma/dma.conf
    fi

    if [ "$SMTP_STARTTLS" = "true" ]; then
        echo "STARTTLS" >> /etc/dma/dma.conf
    fi

    sed -i "s|from@example.com|$SMTP_FROM|g" patch.diff
}

if [ ! -e "$app_path/init" ]; then
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
    echo $SITE_ADMIN > $app_path/www/admins

    replace_news "Anarki" "$SITE_NAME"
    replace_news "http://site.example.com" "$SITE_URL"
    replace_news "http://github.com/arclanguage/anarki" "$PARENT_URL"
    replace_news "What this site is about." "$SITE_DESC"
    replace_news "arc.png" "$SITE_LOGO"
    replace_news_color $SITE_COLOR
    replace_args "-i -n"
    config_smtp

    # Apply patch
    git apply patch.diff

    date > $app_path/init
fi

chown -R bin:root $root_path
cd $app_path && ./run-news
