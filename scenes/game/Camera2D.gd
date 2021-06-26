extends Camera2D

var camera_shake_intensity = 0.0
var camera_shake_duration = 0.0

enum Type {Random}
var camera_shake_type = Type.Random
	

func shake(intensity, duration, type = Type.Random):
	if intensity > camera_shake_intensity and duration > camera_shake_duration:
		camera_shake_intensity = intensity
		camera_shake_duration = duration
		camera_shake_type = type


func _process(delta):
	var camera = self
	
	# Stop shaking if the camera_shake_duration timer is down to zero
	if camera_shake_duration <= 0:
		# Reset the camera when the shaking is done
		camera.offset = Vector2.ZERO
		camera_shake_intensity = 0.0
		camera_shake_duration = 0.0
		return
	
	camera_shake_duration = camera_shake_duration - delta
	
	# Shake it
	var offset = Vector2.ZERO
		
	if camera_shake_type == Type.Random:

		offset = Vector2(randf(), randf()) * camera_shake_intensity
		
	camera.offset = offset
