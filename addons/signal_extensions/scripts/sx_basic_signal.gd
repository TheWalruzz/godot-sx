extends SxSignal
class_name SxBasicSignal


var _signal: Signal
var _handler: Callable


func _init(input_signal: Signal):
	_signal = input_signal
	
	
func _clone() -> SxSignal:
	return SxBasicSignal.new(_signal)


func _subscribe(callback: Callable, variadic := true) -> SxDisposable:
	var source := instance_from_id(_signal.get_object_id())
	var number_of_args := source.get_signal_list() \
		.filter(func(signal_info: Dictionary) -> bool: return signal_info["name"] == _signal.get_name()) \
		.map(func(signal_info: Dictionary) -> int: return signal_info["args"].size()) \
		.front() as int
	
	match number_of_args:
		0: _handler = func(): _handle_signal([], variadic)
		1: _handler = func(arg1): _handle_signal([arg1], variadic)
		2: _handler = func(arg1, arg2): _handle_signal([arg1, arg2], variadic)
		3: _handler = func(arg1, arg2, arg3): _handle_signal([arg1, arg2, arg3], variadic)
		4: _handler = func(arg1, arg2, arg3, arg4): _handle_signal([arg1, arg2, arg3, arg4], variadic)
		5: _handler = func(arg1, arg2, arg3, arg4, arg5): _handle_signal([arg1, arg2, arg3, arg4, arg5], variadic)
		6: _handler = func(arg1, arg2, arg3, arg4, arg5, arg6): _handle_signal([arg1, arg2, arg3, arg4, arg5, arg6], variadic)
		_:
			push_error("Sx does not support more than 6 arguments in a signal. Signal won't be handled.")
			return

	_callback = callback
	_signal.connect(_handler)
	
	return SxDisposable.new(_dispose)
	
	
func _dispose() -> void:
	_signal.disconnect(_handler)
