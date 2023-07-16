# GdUnit generated TestSuite
class_name SxTakeWhileOperatorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/signal_extensions/operators/sx_take_while_operator.gd'


var operator: Sx.TakeWhileOperator
var callback_container: CallbackContainer
var callback_container_spy: Variant


func before_test() -> void:
	callback_container = auto_free(CallbackContainer.new())
	add_child(callback_container)
	callback_container_spy = spy(callback_container)


func test_evaluate() -> void:
	operator = _create_operator(func(value): return value > 0)
	var result := operator.evaluate([1])
	verify_no_interactions(callback_container_spy)
	assert_bool(result.ok).is_true()
	assert_array(result.args).has_size(1).contains([1])
	result = operator.evaluate([2])
	verify_no_interactions(callback_container_spy)
	assert_bool(result.ok).is_true()
	assert_array(result.args).has_size(1).contains([2])
	result = operator.evaluate([0])
	assert_bool(result.ok).is_false()
	verify(callback_container_spy, 1).complete()
	
	
func test_cloning() -> void:
	operator = _create_operator(func(value): return value > 0)
	var cloned := operator.clone()
	assert_object(cloned).is_not_same(operator)
	assert_object(cloned._callable).is_same(operator._callable)
	
	
func _create_operator(callable: Callable) -> Sx.TakeWhileOperator:
	var new_operator = Sx.TakeWhileOperator.new(callable)
	new_operator.dispose_callback = callback_container_spy.complete
	return new_operator
