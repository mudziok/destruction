extends Sprite2D

signal exploded

@onready var fuse = $Fuse
@onready var spark = $"Fuse/Spark"
@onready var deadSpark = $"Fuse/DeadSpark"

var speed = 0.2
var done = false
var stopped = false
var t = 0

func put_out():
	$AudioStreamPlayer.stop()
	stopped = true
	var size = fuse.points.size()
	deadSpark.position = fuse.points[size - 1]
	deadSpark.emitting = true
	spark.emitting = false

func add_time():
	var size = fuse.points.size()
	var current_point = fuse.points[size - 1]
	var target_point = fuse.points[size - 2]
	
	fuse.points[size - 1] = current_point + target_point.direction_to(current_point) * 20.0

func _ready() -> void:
	$AudioStreamPlayer.play()

func _process(delta: float) -> void:
	
	t += delta
	var size = fuse.points.size()
	
	for i in fuse.points.size():
		fuse.points[i].x += sin(t * 2.0) * 0.1 * (float(i) / float(size))
		
	if size == 1:
		if not done:
			done = true
			exploded.emit()
			queue_free()
			
		return
		
	if stopped:
		return
	
	var current_point = fuse.points[size - 1]
	var target_point = fuse.points[size - 2]
	
	fuse.points[size - 1] = lerp(current_point, current_point + current_point.direction_to(target_point) * 20.0, delta * speed)
	spark.position = fuse.points[size - 1]
	if fuse.points[size - 1].distance_to(target_point) < 0.5:
		fuse.points = fuse.points.slice(0, size - 1)
