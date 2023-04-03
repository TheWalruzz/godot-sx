extends SxSignal
class_name SxTimerSignal


var _timer: Timer = null


func _init(timer: Timer):
	_timer = timer


func _clone() -> SxSignal:
	return SxTimerSignal.new(_timer)
	
	
func _is_valid() -> bool:
	return super() and is_instance_valid(_timer) and not _timer.is_stopped()
	
	
func _subscribe(callback: Callable, on_complete: Callable, variadic := true) -> SxDisposable:
	var handler: Callable = func(): _handle_signal(callback, [], variadic)
	_timer.timeout.connect(handler)

	return SxSignalDisposable.new(func():
		if _is_valid():
			if not on_complete.is_null():
				on_complete.call()
			_timer.timeout.disconnect(handler)
			if _timer.timeout.get_connections().size() == 0:
				_timer.stop()
				_timer.queue_free()
	)
