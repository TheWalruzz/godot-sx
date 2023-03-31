extends RefCounted
class_name SxSignal


var _operators: Array[SxOperator] = []
var _is_disposing := false
var _start_with_callable: Callable
var _disposables := SxCompositeDisposable.new()


## Clones the signal object.
## When cloned, the new signal retains all the operators, but is otherwise a completely new object.
func clone() -> SxSignal:
	var result := _clone()
	result._operators.assign(_operators.map(func(operator: SxOperator) -> SxOperator: 
		var op := operator.clone() as SxOperator
		op.dispose_callback = result._set_dispose
		return op
	))
	result._start_with_callable = _start_with_callable
	return result


## Subscribes to the signal. 
## If [b]variadic[/b] is set to false, it will pass an array with values to the [b]callback[/b].
## Otherwise, multiple arguments will be passed.
func subscribe(callback: Callable, variadic := true) -> SxDisposable:
	if not _is_valid():
		push_error("Trying to subscribe to invalid SxSignal.")
		return null
	var disposable := _subscribe(callback, variadic).dispose_with(_disposables)
	if not _start_with_callable.is_null():
		var args := _start_with_callable.call() as Array[Variant]
		_handle_signal(callback, args, variadic)
	return disposable


## Disposes the [SxSignal]. This disconnects all the connected signals and disposes of the subscriptions.
func dispose() -> void:
	_disposables.dispose()


## Delays item emission by [b]duration[/b]. 
## This method has arguments consistent with Godot's [method SceneTree.create_timer] method.
## See that method's documentation for more information.
func delay(duration: float, process_always := true, process_in_physics := false, ignore_timescale := false) -> SxSignal:
	var cloned := clone()
	cloned._operators.append(SxDelayOperator.new(duration, process_always, process_in_physics, ignore_timescale))
	return cloned


## Emits single item at position [b]index[/b] in the sequence.
## The index starts at 0.
func element_at(index: int) -> SxSignal:
	var cloned := clone()
	cloned._operators.append(SxElementAtOperator.new(index))
	cloned._operators.back().dispose_callback = cloned._set_dispose
	return cloned


## Emits only those items that pass a predicate test with a [b]callable[/b].
func filter(callable: Callable) -> SxSignal:
	var cloned := clone()
	cloned._operators.append(SxFilterOperator.new(callable))
	return cloned
	

## Emits only the first item in the sequence.
func first() -> SxSignal:
	var cloned := clone()
	cloned._operators.append(SxFirstOperator.new())
	cloned._operators.back().dispose_callback = cloned._set_dispose
	return cloned
	

## Maps the emitted items using a mapping function.
func map(callable: Callable) -> SxSignal:
	var cloned := clone()
	cloned._operators.append(SxMapOperator.new(callable))
	return cloned
	

## Merges this [SxSignal] with multiple signals in an array.
func merge(signals: Array[SxSignal]) -> SxSignal:
	var combined: Array[SxSignal] = [self]
	combined.append_array(signals)
	return SxMergedSignal.new(combined)


## Skips the first [b]item_count[/b] items from the sequence.
func skip(item_count: int) -> SxSignal:
	var cloned := clone()
	cloned._operators.append(SxSkipOperator.new(item_count))
	return cloned


## Skips emission until the given predicate returns false.
func skip_while(callable: Callable) -> SxSignal:
	var cloned := clone()
	cloned._operators.append(SxSkipWhileOperator.new(callable))
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


## Emits items until the given predicate returns false.
func take_while(callable: Callable) -> SxSignal:
	var cloned := clone()
	cloned._operators.append(SxTakeWhileOperator.new(callable))
	cloned._operators.back().dispose_callback = cloned._set_dispose
	return cloned


func _clone() -> SxSignal:
	return null
	
	
func _is_valid() -> bool:
	return false
	
	
func _subscribe(_callable: Callable, _variadic := true) -> SxDisposable:
	return null


func _set_dispose():
	_is_disposing = true


func _handle_signal(callback: Callable, args: Array[Variant], variadic := true) -> void:
	var result: SxOperatorResult = SxOperatorResult.new(true, args)
	for operator in _operators:
		@warning_ignore("redundant_await")
		result = await operator.evaluate(result.args)
		# this also traps async operators that might still be running when signal becomes invalid
		if not _is_valid() or not result.ok:
			return
	if variadic:
		callback.callv(result.args)
	else:
		callback.call(result.args)
	if _is_disposing:
		dispose()
