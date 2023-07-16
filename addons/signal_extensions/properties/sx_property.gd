extends RefCounted
class_name SxProperty


signal value_changed(new_value: Variant)


var value: Variant:
	get: return value
	set(new_value):
		value = new_value
		value_changed.emit(new_value)


func _init(initial_value: Variant):
	value = initial_value
	

## Observes the value changes in this [SxProperty].
## If [b]emit_initial_value[/b] is set to false, then no value will be emitted on subscription.
## Returns [SxSignal](value)
func as_signal(emit_initial_value := true) -> SxSignal:
	var result := Sx.from(value_changed)
	if emit_initial_value:
		result = result.start_with(func(): return [value])
	return result
