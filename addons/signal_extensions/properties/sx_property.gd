extends RefCounted
class_name SxProperty


signal value_changed(new_value: Variant)


var value: Variant:
	get: return _get_value()
	set(new_value): _set_value(new_value)
	
	
var _value: Variant


func _init(initial_value: Variant):
	_value = initial_value
	

## Observes the value changes in this [SxProperty].
## If [b]emit_initial_value[/b] is set to false, then no value will be emitted on subscription.
## Returns [SxSignal](value)
func as_signal(emit_initial_value := true) -> SxSignal:
	var result := Sx.from(value_changed)
	if emit_initial_value:
		result = result.start_with(func(): return [value])
	return result
	
	
func _get_value() -> Variant:
	return _value
	
	
func _set_value(new_value: Variant) -> void:
	_value = new_value
	value_changed.emit(new_value)
