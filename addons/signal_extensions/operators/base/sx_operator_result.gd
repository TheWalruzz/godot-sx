extends RefCounted


var ok := false
var args: Array[Variant] = []


func _init(status: bool, current_args: Array[Variant]):
	self.ok = status
	self.args = current_args
