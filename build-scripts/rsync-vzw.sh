#!/bin/bash
rsync -azP --delete /var/www/html/kltevzw/ www.chronic-buildbox.com:/var/www/html/kltevzw
rsync -azP --delete /var/www/html/kltevzw/ mirror.chronic-buildbox.com:/var/www/html/kltevzw

