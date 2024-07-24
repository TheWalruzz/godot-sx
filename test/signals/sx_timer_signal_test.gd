# GdUnit generated TestSuite
class_name SxTimerSignalTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/signal_extensions/signals/sx_timer_signal.gd'


var test_signal: Sx.TimerSignal
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
	test_signal = Sx.interval_timer(0.01)
	disposable = test_signal._subscribe(func(): callback_container_spy.function_with_no_params())
	verify_no_interactions(callback_container_spy)
	await await_millis(12)
	verify(callback_container_spy, 1).function_with_no_params()
	await await_millis(10)
	verify(callback_container_spy, 2).function_with_no_params()
	
	
func test_disposal() -> void:
	test_signal = Sx.interval_timer(0.01)
	disposable = test_signal._subscribe(func(): callback_container_spy.function_with_no_params())
	assert_object(disposable).is_not_null()
	verify_no_interactions(callback_container_spy)
	disposable.dispose()
	await await_millis(12)
	verify_no_interactions(callback_container_spy)
	assert_bool(test_signal._is_valid()).is_false()
	
	
func test_disposal_with_completed() -> void:
	test_signal = Sx.interval_timer(0.01)
	disposable = test_signal._subscribe(func(): callback_container_spy.function_with_no_params(), 0, func(): callback_container_spy.complete())
	assert_object(disposable).is_not_null()
	verify_no_interactions(callback_container_spy)
	disposable.dispose()
	await await_millis(12)
	verify(callback_container_spy, 1).complete()
	verify(callback_container_spy, 0).function_with_no_params()
	assert_bool(test_signal._is_valid()).is_false()
