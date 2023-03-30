extends RefCounted
class_name SxProperty


signal value_changed(Variant)


var _value: Variant

var value: Variant:
	get: return _value
	set(new_value):
		_value = new_value
		value_changed.emit(new_value)


func _init(initial_value: Variant):
	_value = initial_value
	
	
func as_signal(emit_initial_value := true) -> SxSignal:
	var result = Sx.from(value_changed)
	if emit_initial_value:
		result = result.start_with([_value])
	return result
