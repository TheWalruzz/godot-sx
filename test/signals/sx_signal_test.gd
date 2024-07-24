# GdUnit generated TestSuite
class_name SxSignalTest
extends GdUnitTestSuite
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

# TestSuite generated from
const __source = 'res://addons/signal_extensions/signals/sx_signal.gd'


signal no_params
signal no_params2
signal one_param(arg)


var test_signal: SxSignal
var callback_container: CallbackContainer
var callback_container_spy: Variant


func before_test() -> void:
	callback_container = auto_free(CallbackContainer.new())
	add_child(callback_container)
	callback_container_spy = spy(callback_container)
	# BasicSignal is used as the generic implementation
	test_signal = Sx.BasicSignal.new(no_params)
	
	
func after_test() -> void:
	test_signal.dispose()


func test_cloning() -> void:
	test_signal = test_signal.first().start_with(func(): return [])
	var cloned := test_signal.clone()
	assert_object(cloned).is_not_same(test_signal)
	assert_array(cloned._operators).has_size(1)
	assert_object(cloned._operators[0]).is_instanceof(Sx.FirstOperator).is_not_same(test_signal._operators[0])
	assert_object(cloned._start_with_callable).is_same(test_signal._start_with_callable)
	cloned.dispose()
	
	
func test_subscribe() -> void:
	var disposable := test_signal.subscribe(func(): pass)
	assert_object(disposable).is_not_null()
	assert_array(test_signal._disposables._disposables).has_size(1).contains([disposable])
	
	
func test_subscribe_with_start_with() -> void:
	test_signal = test_signal.start_with(func(): return [callback_container_spy.returns_one()])
	verify_no_interactions(callback_container_spy)
	var disposable := test_signal.subscribe(func(): callback_container_spy.function_with_no_params())
	assert_object(disposable).is_not_null()
	assert_array(test_signal._disposables._disposables).has_size(1).contains([disposable])
	verify(callback_container_spy, 1).returns_one()
	verify(callback_container_spy, 1).function_with_no_params()
	
	
func test_disposing() -> void:
	var disposable := test_signal.subscribe(func(): pass)
	test_signal.dispose()
	assert_bool(test_signal._is_disposed).is_true()
	assert_bool(disposable.is_disposed).is_true()
	
	
func test_debounce() -> void:
	var with_operator := test_signal.debounce(0.1)
	assert_array(test_signal._operators).has_size(0)
	assert_object(with_operator).is_not_same(test_signal)
	assert_object(with_operator._operators[0]).is_instanceof(Sx.DebounceOperator)
	with_operator.dispose()
	

func test_delay() -> void:
	var with_operator := test_signal.delay(0.1)
	assert_array(test_signal._operators).has_size(0)
	assert_object(with_operator).is_not_same(test_signal)
	assert_object(with_operator._operators[0]).is_instanceof(Sx.DelayOperator)
	with_operator.dispose()
	
	
func test_element_at() -> void:
	var with_operator := test_signal.element_at(1)
	assert_array(test_signal._operators).has_size(0)
	assert_object(with_operator).is_not_same(test_signal)
	assert_object(with_operator._operators[0]).is_instanceof(Sx.ElementAtOperator)
	assert_object(with_operator._operators[0].dispose_callback).is_same(with_operator._set_dispose)
	with_operator.dispose()
	
	
func test_filter() -> void:
	var with_operator := test_signal.filter(func(): return true)
	assert_array(test_signal._operators).has_size(0)
	assert_object(with_operator).is_not_same(test_signal)
	assert_object(with_operator._operators[0]).is_instanceof(Sx.FilterOperator)
	with_operator.dispose()
	
	
func test_first() -> void:
	var with_operator := test_signal.first()
	assert_array(test_signal._operators).has_size(0)
	assert_object(with_operator).is_not_same(test_signal)
	assert_object(with_operator._operators[0]).is_instanceof(Sx.FirstOperator)
	with_operator.dispose()
	
	
func test_map() -> void:
	var with_operator := test_signal.map(func(): return [1])
	assert_array(test_signal._operators).has_size(0)
	assert_object(with_operator).is_not_same(test_signal)
	assert_object(with_operator._operators[0]).is_instanceof(Sx.MapOperator)
	with_operator.dispose()
	
	
func test_merge() -> void:
	var new_signal := test_signal.merge([Sx.BasicSignal.new(no_params2)])
	assert_object(new_signal).is_not_same(test_signal).is_instanceof(Sx.MergedSignal)
	new_signal.dispose()
	
	
func test_merge_from() -> void:
	var new_signal := test_signal.merge_from([no_params2])
	assert_object(new_signal).is_not_same(test_signal).is_instanceof(Sx.MergedSignal)
	new_signal.dispose()


func test_skip() -> void:
	var with_operator := test_signal.skip(2)
	assert_array(test_signal._operators).has_size(0)
	assert_object(with_operator).is_not_same(test_signal)
	assert_object(with_operator._operators[0]).is_instanceof(Sx.SkipOperator)
	with_operator.dispose()
	
	
func test_skip_while() -> void:
	var with_operator := test_signal.skip_while(func(): return true)
	assert_array(test_signal._operators).has_size(0)
	assert_object(with_operator).is_not_same(test_signal)
	assert_object(with_operator._operators[0]).is_instanceof(Sx.SkipWhileOperator)
	with_operator.dispose()
	
	
func test_start_with_callable() -> void:
	var callable := func(): return []
	var with_start_with := test_signal.start_with(callable)
	assert_object(with_start_with).is_not_same(test_signal)
	assert_object(with_start_with._start_with_callable).is_not_null().is_same(callable)
	with_start_with.dispose()


func test_start_with_value() -> void:
	var with_start_with := test_signal.start_with([1])
	assert_object(with_start_with).is_not_same(test_signal)
	assert_object(with_start_with._start_with_callable).is_not_null()
	assert_array(with_start_with._start_with_callable.call()).contains([1])
	with_start_with.dispose()
	
	
func test_take() -> void:
	var with_operator := test_signal.take(1)
	assert_array(test_signal._operators).has_size(0)
	assert_object(with_operator).is_not_same(test_signal)
	assert_object(with_operator._operators[0]).is_instanceof(Sx.TakeOperator)
	assert_object(with_operator._operators[0].dispose_callback).is_same(with_operator._set_dispose)
	with_operator.dispose()
	
	
func test_take_while() -> void:
	var with_operator := test_signal.take_while(func(): return true)
	assert_array(test_signal._operators).has_size(0)
	assert_object(with_operator).is_not_same(test_signal)
	assert_object(with_operator._operators[0]).is_instanceof(Sx.TakeWhileOperator)
	assert_object(with_operator._operators[0].dispose_callback).is_same(with_operator._set_dispose)
	with_operator.dispose()
	

# just a naive test for now
func test_handle_signal() -> void:
	var signal_one_param := Sx.BasicSignal.new(one_param)
	# mocks do not work on non-Nodes yet, so concrete implementation is needed here...
	# this will be changed to a mocked operator when it's possible in gdUnit
	var operator := Sx.FilterOperator.new(func(value): return value > 0)
	signal_one_param._operators.append(operator)
	signal_one_param._handle_signal(func(arg): callback_container_spy.function_with_one_param(arg), [1])
	verify(callback_container_spy).function_with_one_param(1)
	signal_one_param.dispose()
	
	
# TODO: check disposal of multiple subscriptions via operators in _handle_signal
