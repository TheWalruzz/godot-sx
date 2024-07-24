# GdUnit generated TestSuite
class_name SxMergedSignalTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/signal_extensions/signals/sx_merged_signal.gd'


signal first_signal(arg)
signal second_signal(arg)


var test_signal: Sx.MergedSignal
var callback_container: CallbackContainer
var callback_container_spy: Variant
var disposable: SxDisposable


func before_test() -> void:
	callback_container = auto_free(CallbackContainer.new())
	add_child(callback_container)
	callback_container_spy = spy(callback_container)


func after_test() -> void:
	if disposable != null:
		disposable.dispose()


func test_subscribe() -> void:
	test_signal = Sx.merge_from([
		first_signal,
		second_signal
	])
	disposable = test_signal._subscribe(func(arg): callback_container_spy.function_with_one_param(arg))
	verify_no_interactions(callback_container_spy)
	second_signal.emit(2)
	verify(callback_container_spy, 1).function_with_one_param(2)
	first_signal.emit(1)
	verify(callback_container_spy, 1).function_with_one_param(1)
	
	
func test_subscribe_with_empty_array() -> void:
	test_signal = Sx.merge_from([])
	disposable = test_signal._subscribe(func(arg): callback_container_spy.function_with_one_param(arg))
	assert_object(disposable).is_null()
	verify_no_interactions(callback_container_spy)
	
	
func test_disposal() -> void:
	test_signal = Sx.merge_from([
		first_signal,
		second_signal
	])
	disposable = test_signal._subscribe(func(arg): callback_container_spy.function_with_one_param(arg))
	assert_object(disposable).is_not_null()
	verify_no_interactions(callback_container_spy)
	assert_array(first_signal.get_connections()).has_size(1)
	assert_array(second_signal.get_connections()).has_size(1)
	disposable.dispose()
	first_signal.emit(1)
	second_signal.emit(2)
	verify(callback_container_spy, 0).function_with_one_param(1)
	verify(callback_container_spy, 0).function_with_one_param(2)
	assert_array(first_signal.get_connections()).has_size(0)
	assert_array(second_signal.get_connections()).has_size(0)
	
	
func test_disposal_with_completed() -> void:
	test_signal = Sx.merge_from([
		first_signal,
		second_signal
	])
	disposable = test_signal._subscribe(func(arg): callback_container_spy.function_with_one_param(arg), 0, func(): callback_container_spy.complete())
	assert_object(disposable).is_not_null()
	verify_no_interactions(callback_container_spy)
	assert_array(first_signal.get_connections()).has_size(1)
	assert_array(second_signal.get_connections()).has_size(1)
	disposable.dispose()
	first_signal.emit(1)
	second_signal.emit(2)
	verify(callback_container_spy, 0).function_with_one_param(1)
	verify(callback_container_spy, 0).function_with_one_param(2)
	verify(callback_container_spy, 1).complete()
	assert_array(first_signal.get_connections()).has_size(0)
	assert_array(second_signal.get_connections()).has_size(0)
