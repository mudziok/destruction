extends Sprite2D

signal exploded

@onready var fuse = $Fuse
@onready var spark = $"Fuse/Spark"

var speed = 10.0
var done = false
var t = 0
func _process(delta: float) -> void:
	t += delta
	var size = fuse.points.size()
	if size == 1:
		if not done:
			done = true
			exploded.emit()
		return
		
	for i in fuse.points.size():
		fuse.points[i].x += sin(t * 2.0) * 0.1 * (float(i) / float(size))
	
	var current_point = fuse.points[size - 1]
	var target_point = fuse.points[size - 2]
	
	fuse.points[size - 1] = lerp(current_point, target_point, delta * speed)
	spark.position = fuse.points[size - 1]
	if fuse.points[size - 1].distance_to(target_point) < 0.5:
		fuse.points = fuse.points.slice(0, size - 1)
