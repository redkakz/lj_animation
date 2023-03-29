#define LJA_SOURCE_URL						"https://github.com/redkakz/lj_animation"
#define LJA_VERSION							"1.1"

#define PI									3.14159
#define MIN_TRACKING_DISTANCE 				230.0
#define Z_OFFSET_TOLERANCE 					0.1
#define TELEPORT_TOLERANCE 					0.001
#define MAX_JUMP_PRESPEED 					277.0
#define MAX_TRACKING_TICKCOUNT 				141 // pre 40 + air 100 + land 1
#define MIN_PRE_TICKCOUNT 					10
#define MAX_PRE_TICKCOUNT 					40
#define MAX_AIR_TICKCOUNT 					100
#define FLOAT_PRECISION 					100000
#define EMPTYTICKSTATE 						99

#define ANIMATION_PRE_LINE_COLOR			{173,104, 24,255}
#define ANIMATION_AIR_LINE_COLOR			{226,232, 58,255}
#define ANIMATION_POS_POINT_COLOR			{ 10,  7,212,255}
#define ANIMATION_VEL_LINE_COLOR			{222, 27,  9,255}
#define ANIMATION_EYE_LINE_COLOR			{232,232,232,255}
#define ANIMATION_BUTTONS_LINE_COLOR		{  6,189,  0,255}


//     1.       2.       3.       4.       5.       6.       7.       8.       9.      10.      11.      12.      13.      14.      15.
//
//     |       \ /        /               \                 \          /                         |
//  -- O --     O        O        O        O     -- O --     O        O        O        O        O        O --     O     -- O        O
//     |                  \      / \      /                                     \      /                           |

#define FORWARDENDPOINT						{ 1, 0}
#define RIGHTENDPOINT 						{ 0,-1}
#define BACKENDPOINT 						{-1, 0}
#define LEFTENDPOINT 						{ 0, 1}
#define FORWARDLEFTENDPOINT 				{ 1, 1}
#define FORWARDRIGHTENDPOINT 				{ 1,-1}
#define BACKRIGHTENDPOINT 					{-1,-1}
#define BACKLEFTENDPOINT 					{-1, 1}