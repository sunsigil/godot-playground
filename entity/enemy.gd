extends Node2D

var boid: Node2D;

var velocity: Vector2;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boid = get_node("Boid");
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	boid.target = PlayerData.player;
	
func _physics_process(delta: float) -> void:
	velocity = boid.velocity;
	position += velocity * delta;
