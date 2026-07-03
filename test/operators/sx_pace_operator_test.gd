# GdUnit generated TestSuite
class_name SxPaceOperatorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/signal_extensions/operators/sx_pace_operator.gd'
const interval := 0.1

var operator: Sx.PaceOperator


func before_test() -> void:
	operator = Sx.PaceOperator.new(interval, INF, true, false, false)


func test_evaluate_paces_without_dropping() -> void:
	var start := Time.get_ticks_msec()
	var result: Sx.OperatorResult

	# The first item of a burst passes through immediately.
	result = await operator.evaluate([1, 2])
	assert_bool(result.ok).is_true()
	assert_array(result.args).has_size(2).contains([1, 2])
	assert_int(Time.get_ticks_msec() - start).is_less(50)

	# Subsequent items are delayed to keep the interval, never dropped.
	result = await operator.evaluate([3, 4])
	assert_bool(result.ok).is_true()
	assert_array(result.args).has_size(2).contains([3, 4])
	assert_int(Time.get_ticks_msec() - start).is_greater_equal(80)

	result = await operator.evaluate([5, 6])
	assert_bool(result.ok).is_true()
	assert_int(Time.get_ticks_msec() - start).is_greater_equal(180)


func test_evaluate_with_interval_function() -> void:
	operator = Sx.PaceOperator.new(
		func(event_n: int) -> float: return event_n * interval,
		INF, true, false, false
	)
	var start := Time.get_ticks_msec()

	# f(0) = 0 -> immediate.
	await operator.evaluate([1])
	assert_int(Time.get_ticks_msec() - start).is_less(50)

	# f(1) = 0.1 -> spaced from the previous emission.
	await operator.evaluate([2])
	assert_int(Time.get_ticks_msec() - start).is_greater_equal(80)

	# f(2) = 0.2 -> cumulative 0.3.
	await operator.evaluate([3])
	assert_int(Time.get_ticks_msec() - start).is_greater_equal(260)


func test_event_counter_resets_after_silence() -> void:
	operator = Sx.PaceOperator.new(
		func(event_n: int) -> float: return 0.0 if event_n == 0 else 0.5,
		0.1, true, false, false
	)

	await operator.evaluate([1])

	# Silence longer than reset_after: the next item starts a fresh burst -> instant again.
	await await_millis(200)
	var start := Time.get_ticks_msec()
	await operator.evaluate([2])
	assert_int(Time.get_ticks_msec() - start).is_less(50)


func test_cloning() -> void:
	var cloned := operator.clone()
	assert_float(cloned._interval).is_equal(interval)
	assert_float(cloned._reset_after).is_equal(INF)
	assert_bool(cloned._process_always).is_true()
	assert_bool(cloned._process_in_physics).is_false()
	assert_bool(cloned._ignore_timescale).is_false()
	assert_object(cloned).is_not_same(operator)
