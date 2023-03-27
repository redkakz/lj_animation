# lj_animation - csgo server plugin
CSGO GOKZ in-game animation for longjumps.\
Credits for the idea: https://kz-rush.ru/en/article/longjump-physics
-

1. Features:
	- playable in-game longjump animation
	- shows prestrafe ticks
	- visible for everyone on the server, so you can teach others more easily

![alt text](https://github.com/redkakz/lj_animation/blob/main/ljanim_thumbnail.jpg?raw=true)

Only the last validated jump will be animated. The min tracking distance is 230 and the jump has to have at least 10 ticks on the ground before jump. Offset between takeoff and landing, noclipping, teleporting, hitting the wall, being in water, having more than 277 prespeed will invalidate the jump.

2. Setup:
	- Download and install movementapi: https://github.com/danzayau/MovementAPI
	- Download the latest  release.
	- Extract the .smx file into your server's  `csgo/addons/sourcemod/plugins`  directory.
	- Open  `csgo/addons/sourcemod/configs/databases.cfg`  in a text editor and add the following lines before the last "}":
	> "lj_animation"\
		{\
			"driver"  "sqlite"\
			"database"  "lj_animation-sqlite"\
		}

Please let me know if something is broken! Thanks :sparkling_heart:

