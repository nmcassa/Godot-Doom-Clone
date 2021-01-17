extends KinematicBody
const MOVE_SPEED = 4
const MOUSE_SENS = 0.5
var gravity = 9.8
var jump = 3
var fall = Vector3()
 
onready var anim_player = $AnimationPlayer
onready var raycast = $RayCast
onready var playerpos = $Player
 
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	yield(get_tree(), "idle_frame")
	get_tree().call_group("zombies", "set_player", self)
 
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= MOUSE_SENS * event.relative.x
		rotation_degrees.x -= MOUSE_SENS * event.relative.y
		rotation.x = clamp(rotation.x, deg2rad(-90), deg2rad(90))
 
func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	if Input.is_action_pressed("restart"):
		kill()
 
func _physics_process(delta):
	var move_vec = Vector3()
	if not is_on_floor():
		fall.y -= gravity * delta
	if Input.is_action_pressed("move_forwards"):
		move_vec.z -= 1
	if Input.is_action_pressed("move_backwards"):
		move_vec.z += 1
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	if is_on_floor() && Input.is_action_pressed("jump"):
		fall.y = jump
	move_vec = move_vec.normalized()
	move_vec = move_vec.rotated(Vector3(0, 1, 0), rotation.y)
	move_and_collide(move_vec * MOVE_SPEED * delta)
	move_and_slide(fall, Vector3.UP)
	
	if Input.is_action_pressed("shoot") and !anim_player.is_playing():
		anim_player.play("shoot")
		var coll = raycast.get_collider()
		if raycast.is_colliding() and coll.has_method("kill"):
			coll.kill()

func kill():
	get_tree().reload_current_scene()

func _on_Area_area_entered(area):
	get_tree().reload_current_scene()
