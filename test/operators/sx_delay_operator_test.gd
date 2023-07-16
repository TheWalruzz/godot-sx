# GdUnit generated TestSuite
class_name SxDelayOperatorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/signal_extensions/operators/sx_delay_operator.gd'
const delay := 0.01

var operator: Sx.DelayOperator


func before_test() -> void:
	operator = Sx.DelayOperator.new(delay, true, false, false)


func test_evaluate() -> void:
	var result := await operator.evaluate([1, 2])
	assert_bool(result.ok).is_true()
	assert_array(result.args).has_size(2).contains([1, 2])

	
func test_cloning() -> void:
	var cloned := operator.clone()
	assert_float(cloned._delay).is_equal(delay)
	assert_bool(cloned._process_always).is_true()
	assert_bool(cloned._process_in_physics).is_false()
	assert_bool(cloned._ignore_timescale).is_false()
	assert_object(cloned).is_not_same(operator)
