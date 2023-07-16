# GdUnit generated TestSuite
class_name SxTakeOperatorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/signal_extensions/operators/sx_take_operator.gd'


var operator: Sx.TakeOperator
var callback_container: CallbackContainer
var callback_container_spy: Variant


func before_test() -> void:
	callback_container = auto_free(CallbackContainer.new())
	add_child(callback_container)
	callback_container_spy = spy(callback_container)


func test_evaluate() -> void:
	operator = _create_operator(2)
	var result := operator.evaluate([1])
	verify_no_interactions(callback_container_spy)
	assert_bool(result.ok).is_true()
	assert_array(result.args).has_size(1).contains([1])
	result = operator.evaluate([2])
	assert_bool(result.ok).is_true()
	assert_array(result.args).has_size(1).contains([2])
	verify(callback_container_spy, 1).complete()
	
	
func test_evaluate_with_zero_elements() -> void:
	operator = _create_operator(0)
	var result := operator.evaluate([1])
	assert_bool(result.ok).is_false()
	verify(callback_container_spy, 1).complete()

func _create_operator(elements_count: int) -> Sx.TakeOperator:
	var new_operator = Sx.TakeOperator.new(elements_count)
	new_operator.dispose_callback = callback_container_spy.complete
	return new_operator
