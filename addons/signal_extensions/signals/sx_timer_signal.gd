extends SxSignal


var _timer: Timer = null
var _connect_flags: int = 0


func _init(timer: Timer, connect_flags: int = 0):
	_timer = timer
	_connect_flags = connect_flags


func _clone() -> SxSignal:
	return Sx.TimerSignal.new(_timer, _connect_flags)
	
	
func _is_valid() -> bool:
	return super() and is_instance_valid(_timer) and not _timer.is_stopped()
	
	
func _subscribe(callback: Callable, on_complete: Callable, variadic := true) -> SxDisposable:
	var handler: Callable = func(): _handle_signal(callback, [], variadic)
	_timer.timeout.connect(handler, _connect_flags)

	return Sx.SignalDisposable.new(func():
		if _is_valid():
			if not on_complete.is_null():
				on_complete.call()
			_timer.timeout.disconnect(handler)
			if _timer.timeout.get_connections().size() == 0:
				_timer.stop()
				_timer.queue_free()
	)
