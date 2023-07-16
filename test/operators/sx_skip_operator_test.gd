# GdUnit generated TestSuite
class_name SxSkipOperatorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/signal_extensions/operators/sx_skip_operator.gd'


var operator: Sx.SkipOperator


func test_evaluate() -> void:
	operator = Sx.SkipOperator.new(1)
	var result := operator.evaluate([10])
	assert_bool(result.ok).is_false()
	result = operator.evaluate([5])
	assert_bool(result.ok).is_true()
	assert_array(result.args).has_size(1).contains([5])
	result = operator.evaluate([7])
	assert_bool(result.ok).is_true()
	assert_array(result.args).has_size(1).contains([7])
	
	
func test_cloning() -> void:
	operator = Sx.SkipOperator.new(1)
	var cloned := operator.clone()
	assert_object(cloned).is_not_same(operator)
	assert_int(cloned._target_item_count).is_equal(1)
