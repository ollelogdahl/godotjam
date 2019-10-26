# klass för dungeonrum

var x 
var y 
var w
var h

var point
	
func _init(_x, _y, _w, _h):
	self.x = _x
	self.y = _y
	self.w = _w
	self.h = _h
	
func collidesWith(r):
	if x < r.x + r.w and x + w > r.x and y < r.y + r.h and y + h > r.y:
		return true
	return false

func vec3():
	return Vector3(x, y, 0)