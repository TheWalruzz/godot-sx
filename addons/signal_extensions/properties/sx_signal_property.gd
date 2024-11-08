extends SxProperty
class_name SxSignalProperty


func _init(input: SxSignal, initial_value: Variant = null) -> void:
	_value = initial_value
	
	input.subscribe(
		func(arg: Variant):
			_value = arg
			value_changed.emit(arg)
	)
