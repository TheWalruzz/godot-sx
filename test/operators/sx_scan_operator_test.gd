# GdUnit generated TestSuite
class_name SxScanOperatorTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/signal_extensions/operators/sx_scan_operator.gd'


var operator: Sx.ScanOperator


func test_evaluate_returning_variant() -> void:
	operator = Sx.ScanOperator.new(func(acc, value): return acc + value, 0)
	var result := operator.evaluate([3])
	assert_bool(result.ok).is_true()
	assert_array(result.args).has_size(1).contains([3])
	result = operator.evaluate([2])
	assert_bool(result.ok).is_true()
	assert_array(result.args).has_size(1).contains([5])
	
	
func test_evaluate_returning_array() -> void:
	operator = Sx.ScanOperator.new(func(acc, value):
		acc.append(value)
		return acc, 
	[])
	var result := operator.evaluate([3])
	assert_bool(result.ok).is_true()
	assert_array(result.args).has_size(1).contains([[3]])
	result = operator.evaluate([2])
	assert_bool(result.ok).is_true()
	assert_array(result.args).has_size(1).contains([[3, 2]])


func test_cloning() -> void:
	operator = Sx.ScanOperator.new(func(acc, value): return acc + value, 0)
	var cloned := operator.clone()
	assert_object(cloned._callable).is_same(operator._callable)
	assert_object(cloned._initial_value).is_same(operator._initial_value)
	assert_object(cloned).is_not_same(operator)
