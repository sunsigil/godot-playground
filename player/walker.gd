extends Node2D

@export
var body: Node2D;

enum MoveState {
	WALK,
	DASH
};
var state : MoveState = MoveState.WALK;

@export
var speed: float = 600;
@export
var heading_weight: float = 2;
@export
var heading_delay: float = 1;
@export
var velocity_delay: float = 0.1;

var input: Vector2 = Vector2.ZERO;
var input_last: Vector2 = Vector2.ZERO;
var input_delta: Vector2 = Vector2.ZERO;

var input_weight: Vector2 = Vector2.ZERO;
var weight_time: float = 0;

var heading: Vector2 = Vector2.ZERO;
var velocity: Vector2 = Vector2.ZERO;

@export
var dash_waypoint: Node2D;
@export
var dash_range: float = 400;
@export
var dash_duration: float = 0.1;
var dash_position: Vector2;
var dash_target: Vector2 = Vector2.ZERO;
var dash_time: float = 0;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass;
	
func _process(delta):
	queue_redraw();
	
func walk_tick(delta):
	input_last = input;
	input = Vector2.ZERO;
	if Input.is_action_pressed("game_right"):
		input.x += 1;
	if Input.is_action_pressed("game_up"):
		input.y -= 1;
	if Input.is_action_pressed("game_left"):
		input.x -= 1;
	if Input.is_action_pressed("game_down"):
		input.y += 1;
	input_delta = input - input_last;
	
	heading = input.normalized();
	if input_delta != Vector2.ZERO:
		input_weight = abs(input_delta) * heading * heading_weight;
		weight_time = 0;
	if weight_time <= heading_delay:
		heading += input_weight;
		input_weight = lerp(input_weight, Vector2.ZERO, weight_time/heading_delay);
		weight_time += delta;
	
	velocity = lerp(velocity, heading*speed, delta/velocity_delay);
	position += velocity * delta;
	
func dash_start(direction: Vector2):
	direction = direction.normalized();
	dash_position = position;
	dash_target = position + direction * dash_range;
	dash_time = 0;
	state = MoveState.DASH;
	
func dash_tick(delta):
	dash_time += delta;
	var t = dash_time/dash_duration;
	position = lerp(dash_position, dash_target, t);
	if t >= 1:
		state = MoveState.WALK;

func handle_body():
	if body == null:
		return;
	body.rotation = velocity.angle();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match state:
		MoveState.WALK:
			walk_tick(delta);
			if Input.is_action_just_pressed("game_progress"):
				var dash_direction = heading if !dash_waypoint else dash_waypoint.position - position;
				dash_start(dash_direction);
		MoveState.DASH:
			dash_tick(delta);
	handle_body();
	
func _draw():
	var scale_factor = 200;
	draw_line(Vector2.ZERO, input * scale_factor, Color.BLUE);
	draw_line(Vector2.ZERO, heading * scale_factor, Color.RED);
	draw_line(Vector2.ZERO, velocity.normalized() * scale_factor, Color.GREEN);
