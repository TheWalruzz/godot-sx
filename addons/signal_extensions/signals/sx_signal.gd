extends RefCounted
class_name SxSignal


var _operators: Array[Sx.Operator] = []
var _is_disposing := false
var _is_disposed := false
var _start_with_callable: Callable
var _disposables := SxCompositeDisposable.new()
var _waiting_for_disposal := 0


## Clones the signal object.
## When cloned, the new signal retains all the operators, but is otherwise a completely new object.
func clone() -> SxSignal:
	var result := _clone()
	result._operators.assign(_operators.map(func(operator: Sx.Operator) -> Sx.Operator: 
		var op := operator.clone() as Sx.Operator
		op.dispose_callback = result._set_dispose
		return op
	))
	result._start_with_callable = _start_with_callable
	return result


## Subscribes to the signal. 
## If [b]variadic[/b] is set to false, it will pass an array with values to the [b]callback[/b].
## Otherwise, multiple arguments will be passed.
## Optional [b]on_complete[/b] callback can be passed that will be called when this subscription is completed.
func subscribe(callback: Callable, connect_flags := 0, on_complete := Callable(), variadic := true) -> SxDisposable:
	if not _is_valid():
		push_error("Trying to subscribe to invalid SxSignal.")
		return null
	var disposable := _subscribe(callback, connect_flags, on_complete, variadic)
	if disposable == null:
		return null
	disposable.dispose_with(_disposables)
	if not _start_with_callable.is_null():
		var args := _start_with_callable.call() as Array[Variant]
		_handle_signal(callback, args, variadic)
	return disposable


## Disposes the [SxSignal]. This disconnects all the connected signals and disposes the subscriptions.
func dispose() -> void:
	_disposables.dispose()
	_is_disposed = true


## Debounces the signal by [b]debounce_time[/b].
## This method has arguments consistent with Godot's [method SceneTree.create_timer] method.
## See that method's documentation for more information.
func debounce(debounce_time: float, process_always := true, process_in_physics := false, ignore_timescale := false) -> SxSignal:
	var cloned := clone()
	cloned._operators.append(Sx.DebounceOperator.new(debounce_time, process_always, process_in_physics, ignore_timescale))
	return cloned


## Delays item emission by [b]duration[/b]. 
## This method has arguments consistent with Godot's [method SceneTree.create_timer] method.
## See that method's documentation for more information.
func delay(duration: float, process_always := true, process_in_physics := false, ignore_timescale := false) -> SxSignal:
	var cloned := clone()
	cloned._operators.append(Sx.DelayOperator.new(duration, process_always, process_in_physics, ignore_timescale))
	return cloned


## Emits single item at position [b]index[/b] in the sequence.
## The index starts at 0.
func element_at(index: int) -> SxSignal:
	var cloned := clone()
	var operator := Sx.ElementAtOperator.new(index)
	operator.dispose_callback = cloned._set_dispose
	cloned._operators.append(operator)
	return cloned


## Emits only those items that pass a predicate test with a [b]callable[/b].
func filter(callable: Callable) -> SxSignal:
	var cloned := clone()
	cloned._operators.append(Sx.FilterOperator.new(callable))
	return cloned
	

## Emits only the first item in the sequence.
func first() -> SxSignal:
	var cloned := clone()
	var operator := Sx.FirstOperator.new()
	operator.dispose_callback = cloned._set_dispose
	cloned._operators.append(operator)
	return cloned
	

## Maps the emitted items using a mapping function.
func map(callable: Callable) -> SxSignal:
	var cloned := clone()
	cloned._operators.append(Sx.MapOperator.new(callable))
	return cloned
	

## Merges this [SxSignal] with multiple SxSignals in an array.
func merge(signals: Array[SxSignal]) -> SxSignal:
	var combined: Array[SxSignal] = [self]
	combined.append_array(signals)
	return Sx.MergedSignal.new(combined)
	

## Merges this [SxSignal] with multiple Godot signals in an array.
func merge_from(signals: Array[Signal]) -> SxSignal:
	var converted: Array[SxSignal] = []
	converted.assign(signals.map(func(input: Signal): return Sx.BasicSignal.new(input)))
	return merge(converted)


## Scans the emitted items and can reduce them to a single value over time.
## Reducing function: func(acc: ACC_TYPE, ...args: Array[Variant]) -> ACC_TYPE
func scan(callable: Callable, initial_value: Variant) -> SxSignal:
	var cloned := clone()
	cloned._operators.append(Sx.ScanOperator.new(callable, initial_value))
	return cloned


## Skips the first [b]item_count[/b] items from the sequence.
func skip(item_count: int) -> SxSignal:
	var cloned := clone()
	cloned._operators.append(Sx.SkipOperator.new(item_count))
	return cloned


## Skips emission until the given predicate returns false.
func skip_while(callable: Callable) -> SxSignal:
	var cloned := clone()
	cloned._operators.append(Sx.SkipWhileOperator.new(callable))
	return cloned
	

## Starts the sequence with provided values when subscribing.
## [b]callable_or_values[/b] can be a function returning an array of values or just an array of values.
func start_with(callable_or_values: Variant) -> SxSignal:
	var cloned := clone()
	if is_instance_of(callable_or_values, TYPE_CALLABLE):
		cloned._start_with_callable = callable_or_values
	else:
		cloned._start_with_callable = func(): return callable_or_values
	return cloned


## Takes only the first [b]item_count[/b] items from the sequence.
func take(item_count: int) -> SxSignal:
	var cloned := clone()
	var operator := Sx.TakeOperator.new(item_count)
	operator.dispose_callback = cloned._set_dispose
	cloned._operators.append(operator)
	return cloned


## Emits items until the given predicate returns false.
func take_while(callable: Callable) -> SxSignal:
	var cloned := clone()
	var operator := Sx.TakeWhileOperator.new(callable)
	operator.dispose_callback = cloned._set_dispose
	cloned._operators.append(operator)
	return cloned
	
	
## Throttles the signal by [b]throttle_time[/b].
## This method has arguments consistent with Godot's [method SceneTree.create_timer] method.
## See that method's documentation for more information.
func throttle(throttle_time: float, process_always := true, process_in_physics := false, ignore_timescale := false) -> SxSignal:
	var cloned := clone()
	cloned._operators.append(Sx.ThrottleOperator.new(throttle_time, process_always, process_in_physics, ignore_timescale))
	return cloned


func _clone() -> SxSignal:
	return null
	
	
func _is_valid() -> bool:
	return not _is_disposed
	
	
func _subscribe(_callable: Callable, _connect_flags := 0, _on_complete := Callable(), _variadic := true) -> SxDisposable:
	return null


func _set_dispose():
	if not _is_disposing:
		_waiting_for_disposal = _disposables.size()
		_is_disposing = true
	_waiting_for_disposal -= 1


func _handle_signal(callback: Callable, args: Array[Variant], variadic := true) -> void:
	var result: Sx.OperatorResult = Sx.OperatorResult.new(true, args)
	for operator in _operators:
		@warning_ignore("redundant_await")
		result = await operator.evaluate(result.args)
		# this traps async operators that might still be running when signal becomes invalid
		if not _is_valid():
			return
		if not result.ok:
			# handle situations where the operator doesn't allow operator emission, but wants to dispose
			if _is_disposing:
				dispose()
			return
	if variadic:
		callback.callv(result.args)
	else:
		callback.call(result.args)
	if _is_disposing and _waiting_for_disposal == 0:
		dispose()
