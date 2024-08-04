extends Sprite2D

signal exploded

@onready var fuse = $Fuse
@onready var spark = $"Fuse/Spark"
@onready var deadSpark = $"Fuse/DeadSpark"

var speed = 2.0
var done = false
var stopped = false
var t = 0

func put_out():
	stopped = true
	var size = fuse.points.size()
	deadSpark.position = fuse.points[size - 1]
	deadSpark.emitting = true
	spark.emitting = false

func _process(delta: float) -> void:
	
	t += delta
	var size = fuse.points.size()
	
	for i in fuse.points.size():
		fuse.points[i].x += sin(t * 2.0) * 0.1 * (float(i) / float(size))
		
	if size == 1:
		if not done:
			done = true
			exploded.emit()
		return
		
	if stopped:
		return
	
	var current_point = fuse.points[size - 1]
	var target_point = fuse.points[size - 2]
	
	fuse.points[size - 1] = lerp(current_point, target_point, delta * speed)
	spark.position = fuse.points[size - 1]
	if fuse.points[size - 1].distance_to(target_point) < 0.5:
		fuse.points = fuse.points.slice(0, size - 1)
