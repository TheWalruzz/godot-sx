# GdUnit generated TestSuite
class_name SxMapOperatorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/signal_extensions/operators/sx_map_operator.gd'


var operator: Sx.MapOperator


func test_evaluate_returning_variant() -> void:
	operator = Sx.MapOperator.new(func(value): return value * 2)
	var result := operator.evaluate([3])
	assert_bool(result.ok).is_true()
	assert_array(result.args).has_size(1).contains([6])
	
	
func test_evaluate_returning_array() -> void:
	operator = Sx.MapOperator.new(func(value): return [value * 2, value * 3])
	var result := operator.evaluate([3])
	assert_bool(result.ok).is_true()
	assert_array(result.args).has_size(2).contains([6, 9])


func test_cloning() -> void:
	operator = Sx.MapOperator.new(func(value): return value * 2)
	var cloned := operator.clone()
	assert_object(cloned._callable).is_same(operator._callable)
	assert_object(cloned).is_not_same(operator)
