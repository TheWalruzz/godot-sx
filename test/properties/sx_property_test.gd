# GdUnit generated TestSuite
class_name SxPropertyTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/signal_extensions/properties/sx_property.gd'


var property: SxProperty
var callback_container: CallbackContainer
var callback_container_spy: Variant


func before_test() -> void:
	callback_container = auto_free(CallbackContainer.new())
	add_child(callback_container)
	callback_container_spy = spy(callback_container)


func test_as_signal() -> void:
	property = SxProperty.new(1)
	property.as_signal().subscribe(func(value): callback_container_spy.function_with_one_param(value))
	verify(callback_container_spy, 1).function_with_one_param(1)
	
	
func test_as_signal_without_initial_emission() -> void:
	property = SxProperty.new(1)
	property.as_signal(false).subscribe(func(value): callback_container_spy.function_with_one_param(value))
	verify_no_interactions(callback_container_spy)
	
	
func test_value_change() -> void:
	property = SxProperty.new(1)
	property.value_changed.connect(func(value): callback_container_spy.function_with_one_param(value))
	verify_no_interactions(callback_container_spy)
	property.value = 2
	verify(callback_container_spy, 1).function_with_one_param(2)
