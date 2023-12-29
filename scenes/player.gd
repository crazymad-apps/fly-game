extends Area2D

signal hit

@export var speed = 400
var screen_size

@export var bullet_scene: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	screen_size = get_viewport_rect().size
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_forward"):
		velocity.y -= 1
	if Input.is_action_pressed("move_back"):
		velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		if velocity.x != 0:
			$AnimatedSprite2D.animation = "turn_right"
			$AnimatedSprite2D.flip_h = velocity.x < 0
	else:
		$AnimatedSprite2D.animation = "idle"
		
	position += velocity * delta;
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)
	$GunTimer.stop()


# 武器发射
func _on_gun_timer_timeout():
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	$ShotSound.play()

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	$GunTimer.start()
