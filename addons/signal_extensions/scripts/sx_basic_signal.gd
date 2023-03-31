extends SxSignal
class_name SxBasicSignal


var _signal: Signal
var _handlers: Array[Callable] = []


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
	
	var handler: Callable
	match number_of_args:
		0: handler = func(): _handle_signal(callback, [], variadic)
		1: handler = func(arg1): _handle_signal(callback, [arg1], variadic)
		2: handler = func(arg1, arg2): _handle_signal(callback, [arg1, arg2], variadic)
		3: handler = func(arg1, arg2, arg3): _handle_signal(callback, [arg1, arg2, arg3], variadic)
		4: handler = func(arg1, arg2, arg3, arg4): _handle_signal(callback, [arg1, arg2, arg3, arg4], variadic)
		5: handler = func(arg1, arg2, arg3, arg4, arg5): _handle_signal(callback, [arg1, arg2, arg3, arg4, arg5], variadic)
		6: handler = func(arg1, arg2, arg3, arg4, arg5, arg6): _handle_signal(callback, [arg1, arg2, arg3, arg4, arg5, arg6], variadic)
		_:
			push_error("Sx does not support more than 6 arguments in a signal. Signal won't be handled.")
			return

	_signal.connect(handler)
	_handlers.append(handler)
	
	return SxDisposable.new(func(): 
		_signal.disconnect(handler)
		_handlers.erase(handler)
	)
	
	
func _dispose() -> void:
	for handler in _handlers:
		_signal.disconnect(handler)
