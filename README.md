# lj_animation - csgo server plugin

CSGO GOKZ in-game animation for longjumps.\
Credits for the idea: https://kz-rush.ru/en/article/longjump-physics

-

1. Features:
   - playable in-game longjump animation
   - shows prestrafe ticks
   - visible for everyone on the server, so you can teach others more easily

![in-game picture](https://github.com/redkakz/lj_animation/blob/main/ljanim_thumbnail.jpg?raw=true)

Only the last validated jump will be animated. The min tracking distance is 230 and the jump has to have at least 10 ticks on the ground before jump. Offset between takeoff and landing, noclipping, teleporting, being in water, having more than 277 prespeed will invalidate the jump.

3. Requirements:
   - [MovementAPI ^2.1.1](https://github.com/danzayau/MovementAPI)

4. Setup:
   - Download the latest [release](https://github.com/redkakz/lj_animation/releases).
   - Extract the .smx file into your server's `csgo/addons/sourcemod/plugins` directory.

5. Commands:
   - `sm_lja` toggle on/off
   - `sm_ljamenu` open menu

Please let me know if something is broken! Thanks :sparkling_heart:

