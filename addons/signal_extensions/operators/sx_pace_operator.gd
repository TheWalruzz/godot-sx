extends Sx.Operator


var _interval: Variant
var _reset_after: float
var _process_always: bool
var _process_in_physics: bool
var _ignore_timescale: bool

var _event_n := 0
var _last_arrival := -INF
var _last_fire := -INF


func _init(interval: Variant, reset_after: float, process_always: bool, process_in_physics: bool, ignore_timescale: bool):
	_interval = interval
	_reset_after = reset_after
	_process_always = process_always
	_process_in_physics = process_in_physics
	_ignore_timescale = ignore_timescale


func clone() -> Sx.Operator:
	return Sx.PaceOperator.new(_interval, _reset_after, _process_always, _process_in_physics, _ignore_timescale)


func evaluate(args: Array[Variant]) -> Sx.OperatorResult:
	var now := Time.get_ticks_msec() / 1000.0
	if now - _last_arrival > _reset_after:
		_event_n = 0
	_last_arrival = now

	var gap := _gap_for(_event_n)
	# The first event of a burst waits gap from its own arrival; later events space out from the
	# previous fire. Clamp so an event never fires in the past nor before an already-scheduled
	# emission (keeps order even when the interval curve shrinks or a reset lands mid-drain).
	var fire_at := (now + gap) if _event_n == 0 else (_last_fire + gap)
	fire_at = maxf(fire_at, maxf(now, _last_fire))
	_event_n += 1
	_last_fire = fire_at

	var wait := fire_at - now
	if wait > 0.0:
		await Sx.get_tree().create_timer(
			wait,
			_process_always,
			_process_in_physics,
			_ignore_timescale
		).timeout
	return Sx.OperatorResult.new(true, args)


func _gap_for(n: int) -> float:
	if _interval is Callable:
		return float(_interval.call(n))
	if _interval is float:
		return 0.0 if n == 0 else _interval

	push_error("Invalid interval type: %s" % _interval)
	return 0.0
