# GdUnit generated TestSuite
class_name SxFirstOperatorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/signal_extensions/operators/sx_first_operator.gd'


var operator: Sx.FirstOperator


func test_evaluate() -> void:
	var callback_container = auto_free(CallbackContainer.new())
	var callback_container_spy = spy(callback_container)
	operator = Sx.FirstOperator.new()
	operator.dispose_callback = callback_container_spy.function_with_no_params
	verify_no_interactions(callback_container_spy)
	var result := operator.evaluate([1])
	assert_bool(result.ok).is_true()
	assert_array(result.args).has_size(1).contains([1])
	verify(callback_container_spy, 1).function_with_no_params()
	
	
func test_cloning() -> void:
	operator = Sx.FirstOperator.new()
	var cloned := operator.clone()
	assert_object(cloned).is_not_same(operator)
