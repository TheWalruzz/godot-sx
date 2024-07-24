# GdUnit generated TestSuite
class_name SxBasicSignalTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/signal_extensions/signals/sx_basic_signal.gd'


signal no_params
signal one_param(arg)
signal two_params(arg1, arg2)
signal too_many_params(arg1, arg2, arg3, arg4, arg5, arg6, arg7)


var test_signal: Sx.BasicSignal
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


func test_subscribe_no_params() -> void:
	test_signal = Sx.from(no_params)
	disposable = test_signal._subscribe(func(): callback_container_spy.function_with_no_params())
	verify_no_interactions(callback_container_spy)
	no_params.emit()
	verify(callback_container_spy, 1).function_with_no_params()
	
	
func test_subscribe_one_param() -> void:
	test_signal = Sx.from(one_param)
	disposable = test_signal._subscribe(func(arg): callback_container_spy.function_with_one_param(arg))
	verify_no_interactions(callback_container_spy)
	one_param.emit(1)
	verify(callback_container_spy, 1).function_with_one_param(1)
	
	
func test_subscribe_two_params() -> void:
	test_signal = Sx.from(two_params)
	disposable = test_signal._subscribe(func(arg1, arg2): callback_container_spy.function_with_two_params(arg1, arg2))
	verify_no_interactions(callback_container_spy)
	one_param.emit(1, 2)
	verify(callback_container_spy, 1).function_with_two_params(1, 2)
	
	
func test_subscribe_too_many_params() -> void:
	test_signal = Sx.from(too_many_params)
	disposable = test_signal._subscribe(func(arg1, arg2, arg3, arg4, arg5, arg6, arg7): 
		callback_container_spy.function_with_too_many_params(arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	)
	assert_object(disposable).is_null()
	verify_no_interactions(callback_container_spy)
	one_param.emit(1, 2, 3, 4, 5, 6, 7)
	verify_no_interactions(callback_container_spy)
	
	
func test_disposal() -> void:
	test_signal = Sx.from(no_params)
	disposable = test_signal._subscribe(func(): callback_container_spy.function_with_no_params())
	assert_object(disposable).is_not_null()
	verify_no_interactions(callback_container_spy)
	assert_array(no_params.get_connections()).has_size(1)
	disposable.dispose()
	no_params.emit()
	verify(callback_container_spy, 0).function_with_no_params()
	assert_array(no_params.get_connections()).has_size(0)
	
	
func test_disposal_with_completed() -> void:
	test_signal = Sx.from(no_params)
	var disposable := test_signal._subscribe(func(): callback_container_spy.function_with_no_params(), 0, func(): callback_container_spy.complete())
	assert_object(disposable).is_not_null()
	verify_no_interactions(callback_container_spy)
	assert_array(no_params.get_connections()).has_size(1)
	disposable.dispose()
	verify(callback_container_spy, 1).complete()
	verify(callback_container_spy, 0).function_with_no_params()
	assert_array(no_params.get_connections()).has_size(0)
	
	
func test_cloning() -> void:
	test_signal = Sx.from(no_params)
	var cloned := test_signal._clone()
	assert_object(cloned).is_not_same(test_signal)
	assert_object(cloned._signal).is_same(test_signal._signal)
	cloned.dispose()
