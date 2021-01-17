extends KinematicBody
 
const MOVE_SPEED = 2

var fall = Vector3()

var gravity = 9.8
 
onready var raycast = $RayCast
onready var anim_player = $AnimationPlayer
var playerscene = preload("res://Player.tscn")
var instance = playerscene.instance()
 
var player = null
var dead = false

func _ready():
	anim_player.play("walk")
	add_to_group("zombies")
 
func _physics_process(delta):
	if dead:
		return
	if player == null:
		return
	anim_player.play("walk")
	if not is_on_floor():
		fall.y -= gravity * delta
	
	var vec_to_player = player.translation - translation
	vec_to_player = vec_to_player.normalized()
	raycast.cast_to = vec_to_player * 1.5
	look_at(vec_to_player * 10000, Vector3(0, 1, 0))
	move_and_collide(vec_to_player * MOVE_SPEED * delta)
	
	
 
func kill():
	dead = true
	$CollisionShape.disabled = true
	anim_player.play("die")
 
func set_player(p):
	player = p

func _on_Area_area_entered(area):
	get_tree().reload_current_scene()
