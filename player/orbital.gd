extends Node2D

@export
var body: Node2D;
@export
var radius: float = 0;
@export
var delay: float = 0.1;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _physics_process(delta: float) -> void:
	var arm = Vector2.UP.rotated(rotation) * radius;
	position = body.position + arm;
	var leg = get_global_mouse_position() - body.position;
	leg = leg.normalized() * radius;
	var arc = arm.angle_to(leg);
	rotation += arc * delta / delay;
	pass;
