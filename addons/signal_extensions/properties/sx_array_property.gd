extends RefCounted
class_name SxArrayProperty


enum Event {
	UPDATED_LIST,
	UPDATED,
	ERASED,
	CLEARED,
	COUNT_CHANGED,
}


signal value_changed(type, array, payload)


var value: Array = []:
	get: return value

var _last_size := 0


func _init(initialvalue: Array = []):
	value = initialvalue
	_last_size = value.size()

	Sx.from(value_changed).filter(func(type: SxArrayProperty.Event, array: Array, _z):
		return type != Event.COUNT_CHANGED and _last_size != array.size()
	).subscribe(func(_x, array: Array, _z):
		value_changed.emit(Event.COUNT_CHANGED, array, array.size())
		_last_size = array.size()
	)


func _iter_init(arg) -> bool:
	arg[0] = 0
	return _iter_should_continue(arg)


func _iter_next(arg) -> bool:
	arg[0] += 1
	return _iter_should_continue(arg)


func _iter_get(current_index) -> Variant:
	return value[current_index]


func _iter_should_continue(arg) -> bool:
	return arg[0] < size()


func append(item: Variant) -> void:
	value.append(item)
	value_changed.emit(Event.UPDATED, value, item)


func append_array(items: Array) -> void:
	value.append_array(items)
	value_changed.emit(Event.UPDATED_LIST, value, items)


func assign(items: Array) -> void:
	value.assign(items)
	value_changed.emit(Event.UPDATED_LIST, value, items)


func clear() -> void:
	value.clear()
	value_changed.emit(Event.CLEARED, value, null)


func erase(item: Variant) -> void:
	value.erase(item)
	value_changed.emit(Event.ERASED, value, item)


func fill(item: Variant) -> void:
	value.fill(item)
	value_changed.emit(Event.UPDATED_LIST, value, value)


func get_index(position: int) -> Variant:
	return value[position]


func has(item: Variant) -> bool:
	return value.has(item)


func insert(position: int, item: Variant) -> void:
	value.insert(position, item)
	value_changed.emit(Event.UPDATED, value, item)


func pop_at(index: int) -> Variant:
	var item = value.pop_at(index)
	value_changed.emit(Event.ERASED, value, item)
	return item


func pop_back() -> Variant:
	var item = value.pop_back()
	value_changed.emit(Event.ERASED, value, item)
	return item


func pop_front() -> Variant:
	var item = value.pop_front()
	value_changed.emit(Event.ERASED, value, item)
	return item


func push_back(item: Variant) -> void:
	value.push_back(item)
	value_changed.emit(Event.UPDATED, value, item)


func push_front(item: Variant) -> void:
	value.push_back(item)
	value_changed.emit(Event.UPDATED, value, item)


func remove_at(position: int) -> void:
	var item = value[position]
	value.remove_at(position)
	value_changed.emit(Event.ERASED, value, item)


func set_index(position: int, item: Variant) -> void:
	value[position] = item
	value_changed.emit(Event.UPDATED, value, item)


func size() -> int:
	return value.size()


## Observes every type of event with [enum Event] in the [SxArrayProperty].
## [b]emit_initialvalue[/b] can be set to false to not emit current value on subscription.
## Returns [SxSignal](Event, array, payload).
func as_signal(emit_initialvalue := true) -> SxSignal:
	var result := Sx.from(value_changed)
	if emit_initialvalue:
		result = result.start_with(func(): return [Event.UPDATED_LIST, value, value])
	return result


## Observes specific event with [enum Event]
## [b]emit_initialvalue[/b] can be set to false to not emit current value on subscription.
## Returns [SxSignal](array, payload).
func observe(event: Event, emit_initialvalue := true) -> SxSignal:
	return as_signal(emit_initialvalue).filter(func(type: Event, _y, _z): return type == event) \
		.map(func(_x, array: Array, payload: Variant): return [array, payload])
