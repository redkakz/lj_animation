# lj_animation - csgo server plugin
CSGO GOKZ in-game animation for longjumps.\
Credits for the idea: https://kz-rush.ru/en/article/longjump-physics
-

1. Features:
	- playable in-game longjump animation
	- shows prestrafe ticks
	- visible for everyone on the server

![alt text](https://github.com/redkakz/lj_animation/blob/main/ljanim_thumbnail.jpg?raw=true)

2. Setup:
	- Download the latest  release.
	- Extract the files into your server's  `csgo`  directory.
	- Open  `csgo/addons/sourcemod/configs/databases.cfg`  in a text editor and add the following lines before the last "}":
	> "lj_animation"
		{
			"driver"  "sqlite"
			"database"  "lj_animation-sqlite"
		}

Please let me know if something is broken! Thanks :sparkling_heart:

