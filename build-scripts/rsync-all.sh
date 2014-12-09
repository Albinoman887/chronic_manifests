#!/bin/bash
rsync -azP --delete /var/www/html/ www.chronic-buildbox.com:/var/www/html
rsync -azP --delete /var/www/html/ mirror.chronic-buildbox.com:/var/www/html
