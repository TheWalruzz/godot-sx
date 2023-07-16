# GdUnit generated TestSuite
class_name SxElementAtOperatorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/signal_extensions/operators/sx_element_at_operator.gd'

var operator: Sx.ElementAtOperator
var callback_container: CallbackContainer
var callback_container_spy: Variant


func before_test() -> void:
	callback_container = auto_free(CallbackContainer.new())
	add_child(callback_container)
	callback_container_spy = spy(callback_container)


func test_evaluate() -> void:
	operator = _create_operator(1)
	var result := operator.evaluate([1])
	verify_no_interactions(callback_container_spy)
	assert_bool(result.ok).is_false()
	result = operator.evaluate([2])
	assert_bool(result.ok).is_true()
	assert_array(result.args).has_size(1).contains([2])
	verify(callback_container_spy, 1).complete()
	
	
func test_cloning() -> void:
	operator = _create_operator(1)
	var cloned := operator.clone()
	assert_int(cloned._element_index).is_equal(1)
	assert_object(cloned).is_not_same(operator)
	
	
func _create_operator(index: int) -> Sx.ElementAtOperator:
	var new_operator = Sx.ElementAtOperator.new(index)
	new_operator.dispose_callback = callback_container_spy.complete
	return new_operator
