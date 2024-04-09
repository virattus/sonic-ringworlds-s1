extends Node



const IDLE_MIN_GROUND_ANGLE = 0.5

const RUN_MAX_SPEED = 18.0
const MOVE_MAX_SPEED = 40.0

const MOVE_STRIKEDASH_ANIM_SPEED_MODIFIER = 1.0
const MOVE_RUN_ANIM_MAX_SPEED = 20.0
const MOVE_RUN_ANIM_SPEED_MODIFIER = 1.0
const MOVE_WALK_ANIM_MAX_SPEED = 15.0
const MOVE_WALK_ANIM_SPEED_MODIFIER = 0.5
const MOVE_RAYCAST_SNAP_MAX_DISTANCE = 0.7

const MOVE_MIN_SPEED = 0.1
const MOVE_INPUT_SCALE = 10.0
const MOVE_GROUND_STICK_MIN_ANGLE = 0.5
const MOVE_GROUND_STICK_REQ_SPEED = 5.0
const MOVE_FLOOR_NORMAL_DOT_MIN = 0.9
const MOVE_GRIP_LOST_EJECTION_MAGNITUDE = 1.0

const RUN_INPUT_MAGNITUDE = 0.5
const RUN_ACCEL_RATE = 0.25
const RUN_DECEL_RATE = 1.0

const JUMP_POWER = 40.0
const JUMP_POWER_DECEL = 70.0


const AIR_MAX_SPEED = 20.0
const AIR_INPUT_MAGNITUDE = 0.025
const AIR_CEILING_ANGLE_MAX = -0.9
const AIR_ACCEL_RATE = 1.0
const AIR_DECEL_RATE = 1.0
const AIR_RAYCAST_SNAP_MAX_DIST = MOVE_RAYCAST_SNAP_MAX_DISTANCE

const FALL_WALL_DOT_MIN = 0.3
const FALL_CEILING_DOT_MIN = -0.8

const AIRDASH_INITIAL_SPEED = 25.0
const AIRDASH_SPEED_DECREASE_RATE = 20.0
const AIRDASH_WALL_BONK_MIN = -0.5
const AIRDASH_WALL_BONK_MAX = 0.5

const LAND_ANGLE_MIN = 0.5
const LAND_WIPEOUT_MIN = -0.25
const LAND_WALL_MIN = 0.75

const SKID_ANGLE_MIN = -0.6
const SKID_INPUT_MIN = 0.3
const SKID_MIN_REQUIRED_SPEED = 10.0
const SKID_SPEED_REDUCTION_RATE = 6.0
const SKID_END_MIN_SPEED = 1.0


const WIPEOUT_MIN_SLIDE_SPEED = 3.0
const WIPEOUT_SPEED_REDUCTION_RATE = 1.0
const WIPEOUT_MIN_SPEED = 1.0

const SQUATCHARGE_ADDED_POWER = 7.0

const HURT_INITIAL_UP_SPEED = 8.0
const HURT_INVINCIBILITY_TIME = 2.0

const DEATH_INITIAL_VERTICAL_VELOCITY = 5.0

const GRAVITY = 15.0
const FLICKER_TIME = 0.05

