extends Node

# Player signals
# Connected from ship's action timer to HUD
signal dash
signal dash_regen

# Quest signals
# Connected from damage rock to Ship
signal rock_mined(attacker)
# Connected from enemy to Ship
signal enemy_killed(object)
# Connected from Energy Stations to Quest class
signal start_charging_battery
signal stop_charging_battery
# Connected from Ship to Quest class
signal damage_taken

# Other object signals

# UI signals
signal new_player_connected(id)
# Connected from ship to gameOverScreen
signal player_died(score)
# Connected from shop Quest menu to Ship and HUD Quest labels
signal quest_received(content)
# Connected from Quest class to HUD Quest labels and Ship
signal quest_progressed
# Connected from Quest class to HUD Quest labels
signal quest_completed
# Connected from Quest class to HUD Quest labels
signal quest_failed
# Connected from Carrier to HUD Quest labels
signal quest_removed
# Connected from Carrier to HUD Credits label and Ship
signal credits_updated
# Connected from Carrier to HUD leaderboard
signal score_updated
# Connected from Quest class to Ship's QuestTimerBar
signal show_quest_timer
# Connected from Quest class to Ship's IndicatorArrow
signal show_indicator_arrow

signal upgrade_special(id,val)


#vvvvv THIS IS FOR JOE vvvvv
#ONLY DELETE IF YOU HATE HIM AND/OR WANT HIM DEAD.

# THESE ARE USED FOR ERROR CODES THAT YOU GET FROM THE typeof() FUNCTION
# FULL LIST HERE
# https://docs.godotengine.org/en/3.2/classes/class_@globalscope.html#enumerations:~:text=Default%20method%20flags.-,enum%20Variant.Type%3A,-TYPE_NIL%20%3D%200
var DATATYPE = {
	0:"TYPE_NIL",
	1:"TYPE_BOOL",
	2:"TYPE_INT",
	3:"TYPE_REAL",
	4:"TYPE_STRING",
	5:"TYPE_VECTOR2",
	6:"TYPE_RECT2",
	7:"TYPE_VECTOR3",
	8:"TYPE_TRANSFORM2D",
	9:"TYPE_PLANE",
	10:"TYPE_QUAT",
	11:"TYPE_AABB",
	12:"TYPE_BASIS",
	13:"TYPE_TRANSFORM",
	14:"TYPE_COLOR",
	15:"TYPE_NODE_PATH ",
	16:"TYPE_RID",
	17:"TYPE_OBJECT",
	18:"TYPE_DICTIONARY",
	19:"TYPE_ARRAY",
	20:"TYPE_RAW_ARRAY",
	21:"TYPE_INT_ARRAY",
	22:"TYPE_REAL_ARRAY",
	23:"TYPE_STRING_ARRAY ",
	24:"TYPE_VECTOR2_ARRAY",
	25:"TYPE_VECTOR3_ARRAY",
	26:"TYPE_COLOR_ARRAY",
	27:"TYPE_MAX",
}
