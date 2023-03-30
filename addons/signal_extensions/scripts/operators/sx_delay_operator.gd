extends SxOperator
class_name SxDelayOperator


var _delay: float
var _process_always: bool
var _process_in_physics: bool
var _ignore_timescale: bool


func _init(delay: float, process_always: bool, process_in_physics: bool, ignore_timescale: bool):
	_delay = delay
	_process_always = process_always
	_process_in_physics = process_in_physics
	_ignore_timescale = ignore_timescale
	
	
func clone() -> SxOperator:
	return SxDelayOperator.new(_delay, _process_always, _process_in_physics, _ignore_timescale)
	
	
func evaluate(args: Array[Variant]) -> SxOperatorResult:
	await Sx.get_tree().create_timer(_delay, _process_always, _process_in_physics, _ignore_timescale).timeout
	return SxOperatorResult.new(true, args)
