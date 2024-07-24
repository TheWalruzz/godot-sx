extends Sx.Operator


var _throttle_time: float
var _process_always: bool
var _process_in_physics: bool
var _ignore_timescale: bool
var _is_throttling := false


func _init(throttle_time: float, process_always: bool, process_in_physics: bool, ignore_timescale: bool):
	_throttle_time = throttle_time
	_process_always = process_always
	_process_in_physics = process_in_physics
	_ignore_timescale = ignore_timescale
	
	
func clone() -> Sx.Operator:
	return Sx.ThrottleOperator.new(_throttle_time, _process_always, _process_in_physics, _ignore_timescale)
	
	
func evaluate(args: Array[Variant]) -> Sx.OperatorResult:
	if not _is_throttling:
		_is_throttling = true
		Sx.get_tree().create_timer(
			_throttle_time,
			_process_always,
			_process_in_physics,
			_ignore_timescale
		).timeout.connect(
			func(): _is_throttling = false,
			CONNECT_ONE_SHOT
		)
		return Sx.OperatorResult.new(true, args)
	return Sx.OperatorResult.new(false, args)
