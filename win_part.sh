#!/bin/sh

# Windows partition
	# Downloads & Desktop
rsync -abAXv --backup-dir=#old_`date +%F` --exclude=#old_* --delete /home/flo/Win_Part/Users/Flo/Downloads/ /run/media/flo/3TB_Drive/Rsync/win/Downloads

rsync -abAXv --backup-dir=#old_`date +%F` --exclude=#old_* --delete /home/flo/Win_Part/Users/Flo/Desktop/ /run/media/flo/3TB_Drive/Rsync/win/Desktop

	#Documents
rsync -abAXv --backup-dir=#old_`date +%F` --exclude=#old_* --delete /home/flo/Win_Part/Users/Flo/Documents/ /run/media/flo/3TB_Drive/Rsync/win/Documents	

	# Music
rsync -abAXv --delete --exclude=iTunes/ --exclude=AWOLNATION/ --exclude=Playlists/ --exclude=Fabri\ Fibra/ --exclude=Zedd/ --exclude=Monstercat/ --exclude=+exclude/ --delete /run/media/flo/3TB_Drive/Robocopy/Media_Drive/Music/ /home/flo/Win_Part/Users/Flo/Music
 
