#!/bin/bash
rsync -abv --delete --exclude=iTunes/ --exclude=+exclude/ --delete /run/media/flo/3TB_Drive/Robocopy/Media_Drive/Music/ /run/media/flo/Win_Part/Users/Flo/Music/
