extends Node2D

enum MoveState {
	WALK,
	DASH
};
var state : MoveState = MoveState.WALK;

@export
var speed: float = 600;

var input: Vector2 = Vector2.ZERO;
var input_last: Vector2 = Vector2.ZERO;
var input_delta: Vector2 = Vector2.ZERO;
var input_weight: Vector2 = Vector2.ZERO;

var heading: Vector2 = Vector2.ZERO;
var velocity: Vector2 = Vector2.ZERO;

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
		
	input_weight += abs(input_delta) * input * 2;
	heading = input.normalized() + input_weight;
	input_weight *= 0.75;
	
	velocity = lerp(velocity, heading, 8*delta);
	position += velocity * speed * delta;
	
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	match state:
		MoveState.WALK:
			walk_tick(delta);
			if Input.is_action_just_pressed("game_progress"):
				dash_start(heading);
		MoveState.DASH:
			dash_tick(delta);
	
func _draw():
	draw_line(Vector2.ZERO, input * speed, Color.BLUE);
	draw_line(Vector2.ZERO, heading*speed, Color.RED);
	draw_line(Vector2.ZERO, velocity*speed, Color.GREEN);
