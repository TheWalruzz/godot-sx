extends SxSignal


var _timer: Timer = null


func _init(timer: Timer):
	_timer = timer


func _clone() -> SxSignal:
	return Sx.TimerSignal.new(_timer)
	
	
func _is_valid() -> bool:
	return super() and is_instance_valid(_timer) and not _timer.is_stopped()
	
	
func _subscribe(callback: Callable, connect_flags := 0, on_complete := Callable(), variadic := true) -> SxDisposable:
	var handler: Callable = func(): _handle_signal(callback, [], variadic)
	_timer.timeout.connect(handler, connect_flags)

	return Sx.SignalDisposable.new(func():
		if _is_valid():
			if not on_complete.is_null():
				on_complete.call()
			_timer.timeout.disconnect(handler)
			if _timer.timeout.get_connections().size() == 0:
				_timer.stop()
				_timer.queue_free()
	)
