extends Node2D

@export
var target: Node;
@export
var group: String;

@export
var speed: float = 600;
var velocity: Vector2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if target == null:
		return;
	var heading = (target.global_position - global_position).normalized();
	velocity = heading * speed;
