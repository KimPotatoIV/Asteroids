extends RigidBody2D

##################################################
const MOVING_SPEED: float = 100.0
const SMALL_ASTEROID: PackedScene = \
	preload("res://scenes/asteroid_small/asteroid_small.tscn")
var velocity: Vector2 = Vector2.ZERO

##################################################
func _ready() -> void:
	add_to_group("Asteroid")
	gravity_scale = 0.0
	velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * MOVING_SPEED
	connect("body_entered", Callable(self, "_on_body_entered"))

##################################################
func _physics_process(delta: float) -> void:
	linear_velocity = velocity
	wrap_around_screen()

##################################################
func wrap_around_screen():
	var screen_size: Vector2 = Vector2(1920.0, 1080.0)
	position.x = fmod(global_position.x + screen_size.x, screen_size.x)
	position.y = fmod(global_position.y + screen_size.y, screen_size.y)

##################################################
func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Bullet"):
		SignalBus.emit_asteroid_damaged()
		GameManager.set_score(GameManager.get_score() + 50)
		call_deferred("split_asteroid")
		body.queue_free()
		queue_free()
	elif body.is_in_group("Player"):
		SignalBus.emit_player_damaged()

##################################################
func split_asteroid() -> void:
	var asteroid_1: Node2D = SMALL_ASTEROID.instantiate()
	var asteroid_2: Node2D = SMALL_ASTEROID.instantiate()
	asteroid_1.global_position = position
	asteroid_2.global_position = position
	get_parent().add_child(asteroid_1)
	get_parent().add_child(asteroid_2)
