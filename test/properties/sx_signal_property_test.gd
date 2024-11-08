# GdUnit generated TestSuite
class_name SxSignalPropertyTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/signal_extensions/properties/sx_signal_property.gd'


signal number(value: int)


var property: SxSignalProperty
var callback_container: CallbackContainer
var callback_container_spy: Variant


func before_test() -> void:
	callback_container = auto_free(CallbackContainer.new())
	add_child(callback_container)
	callback_container_spy = spy(callback_container)
	
	
func test_value_change_on_signal_emission() -> void:
	property = SxSignalProperty.new(Sx.from(number), 0)
	property.value_changed.connect(func(value): callback_container_spy.function_with_one_param(value))
	verify_no_interactions(callback_container_spy)
	number.emit(2)
	assert_int(property.value).is_equal(2)
	verify(callback_container_spy, 1).function_with_one_param(2)
