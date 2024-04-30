extends Node



const IDLE_MIN_GROUND_ANGLE = 0.5

#We have separate values for the dashmode charge gauge and for when you actually enter 
#Dash mode. This is so that the gauge doesn't jump from 100 to 99% every frame on the HUD, 
#it's purely visual.
const DASHMODE_MIN_CHARGE = 0.0
const DASHMODE_MAX_CHARGE = 1.1
const DASHMODE_ABS_MIN_CHARGE = 0.0
const DASHMODE_ABS_MAX_CHARGE = 1.0

const DASHMODE_NORMAL_DISCHARGE_RATE = 0.01
const DASHMODE_ACTIVE_DISCHARGE_RATE = 0.08
const DASHMODE_RING_INCREMENT = 0.03

const RUN_MAX_SPEED = 14.0
const MOVE_MAX_SPEED = 25.0

const MOVE_STRIKEDASH_ANIM_SPEED_MODIFIER = 1.0
const MOVE_RUN_ANIM_MAX_SPEED = 18.0
const MOVE_RUN_ANIM_SPEED_MODIFIER = 1.0
const MOVE_WALK_ANIM_MAX_SPEED = 12.0
const MOVE_WALK_ANIM_SPEED_MODIFIER = 0.5
const MOVE_RAYCAST_SNAP_MAX_DISTANCE = 0.7

const MOVE_MIN_SPEED = 0.1
const MOVE_INPUT_SCALE = 10.0
const MOVE_GROUND_STICK_MIN_ANGLE = 0.5
const MOVE_GROUND_STICK_REQ_SPEED = 5.0
const MOVE_FLOOR_NORMAL_DOT_MIN = 0.9
const MOVE_GRIP_LOST_EJECTION_MAGNITUDE = 1.0

const RUN_INPUT_MAGNITUDE = 0.5
const RUN_ACCEL_RATE = 0.125
const RUN_DECEL_RATE = 2.0

const JUMP_POWER = 9.0
const JUMP_INPUT_VEL_MAX = 1.0


const AIR_MAX_SPEED = 8.0
const AIR_INPUT_MAGNITUDE = 0.025
const AIR_CEILING_ANGLE_MAX = -0.9
const AIR_ACCEL_RATE = 1.0
const AIR_DECEL_RATE = 1.0
const AIR_RAYCAST_SNAP_MAX_DIST = MOVE_RAYCAST_SNAP_MAX_DISTANCE
const AIR_CAM_FOCUS_MAX_HEIGHT = 1.0
const AIR_CAM_FOCUS_MIN_HEIGHT = -1.0

const FALL_WALL_DOT_MIN = 0.3
const FALL_CEILING_DOT_MIN = -0.8

const AIRDASH_INITIAL_SPEED = 25.0
const AIRDASH_SPEED_DECREASE_RATE = 20.0
const AIRDASH_WALL_BONK = -0.5

const ATTACK_BOUNCE_POW = 1.0

const LAND_FLOOR_DOT_MIN = 0.5
const LAND_WALL_DOT_MIN = 0.75

const LAND_WIPEOUT_MIN = -0.25

const SKID_ANGLE_MIN = -0.6
const SKID_INPUT_MIN = 0.3
const SKID_MIN_REQUIRED_SPEED = 10.0
const SKID_SPEED_REDUCTION_RATE = 3.0
const SKID_END_MIN_SPEED = 2.0


const WIPEOUT_MIN_SLIDE_SPEED = 3.0
const WIPEOUT_SPEED_REDUCTION_RATE = 1.0
const WIPEOUT_MIN_SPEED = 1.0

const SQUATCHARGE_ADDED_POWER = 7.0

const HURT_INITIAL_UP_SPEED = 8.0
const HURT_INVINCIBILITY_TIME = 2.0

const DEATH_INITIAL_VERTICAL_VELOCITY = 5.0

const GRAVITY = 10.0
const FLICKER_TIME = 0.05

