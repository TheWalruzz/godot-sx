# GdUnit generated TestSuite
class_name SxSkipWhileOperatorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/signal_extensions/operators/sx_skip_while_operator.gd'


var operator: Sx.SkipWhileOperator


func test_evaluate() -> void:
	operator = Sx.SkipWhileOperator.new(func(value): return value <= 0)
	var result := operator.evaluate([-1])
	assert_bool(result.ok).is_false()
	result = operator.evaluate([0])
	assert_bool(result.ok).is_false()
	result = operator.evaluate([1])
	assert_bool(result.ok).is_true()
	assert_array(result.args).has_size(1).contains([1])
	
	
func test_cloning() -> void:
	operator = Sx.SkipWhileOperator.new(func(value): return value < 0)
	var cloned := operator.clone()
	assert_object(cloned).is_not_same(operator)
	assert_object(cloned._callable).is_same(operator._callable)
