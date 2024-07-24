extends Sx.Operator


var _debounce_time: float
var _process_always: bool
var _process_in_physics: bool
var _ignore_timescale: bool
var _last_result: Sx.OperatorResult = Sx.OperatorResult.new(false, [])
var _last_signal: Signal


func _init(debounce_time: float, process_always: bool, process_in_physics: bool, ignore_timescale: bool):
	_debounce_time = debounce_time
	_process_always = process_always
	_process_in_physics = process_in_physics
	_ignore_timescale = ignore_timescale
	
	
func clone() -> Sx.Operator:
	return Sx.DebounceOperator.new(_debounce_time, _process_always, _process_in_physics, _ignore_timescale)
	
	
func evaluate(args: Array[Variant]) -> Sx.OperatorResult:
	_last_result = Sx.OperatorResult.new(false, [])
	
	if not _last_signal.is_null():
		for connection in _last_signal.get_connections():
			_last_signal.disconnect(connection.callable)
			
	_last_signal = Sx.get_tree().create_timer(
		_debounce_time,
		_process_always,
		_process_in_physics,
		_ignore_timescale
	).timeout
	_last_signal.connect(
		func(): _last_result = Sx.OperatorResult.new(true, args),
		CONNECT_ONE_SHOT
	)
	await _last_signal
	return _last_result
