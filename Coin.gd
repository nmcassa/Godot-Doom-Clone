extends KinematicBody

onready var anim_player = $AnimationPlayer
var player = null
onready var raycast = $RayCast

var playerscene = preload("res://Player.tscn")
var instance = playerscene.instance()

func _ready():
	anim_player.play("spin")

func _physics_process(delta):
	anim_player.play("spin")
	
	if player == null: 
		return
	var vec_to_player = player.translation - translation
	vec_to_player = vec_to_player.normalized()
	raycast.cast_to = vec_to_player * 1.5
	look_at(vec_to_player * 10000, Vector3(0, 1, 0))
	move_and_collide(vec_to_player * 0 * delta)

func set_player(p):
	player = p
