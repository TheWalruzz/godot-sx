extends RefCounted
class_name SxArrayProperty


enum Type {
	UPDATED_LIST,
	UPDATED,
	ERASED,
	CLEARED,
	COUNT_CHANGED,
}


signal value_changed(type, array, payload)


var _value: Array = []
var value: Array:
	get: return _value
	
var _last_size := 0
var _iter_current_index := 0
	

func _init(initial_value: Array = []):
	_value = initial_value
	_last_size = _value.size()
	
	Sx.from(value_changed).filter(func(type: Type, array: Array, _z):
		return type != Type.COUNT_CHANGED and _last_size != array.size()
	).subscribe(func(_x, array: Array, _z): 
		value_changed.emit(Type.COUNT_CHANGED, array, array.size())
		_last_size = array.size()
	)


func _iter_init(_arg) -> bool:
	_iter_current_index = 0
	return _iter_should_continue()


func _iter_next(_arg) -> bool:
	_iter_current_index += 1
	return _iter_should_continue()


func _iter_get(_arg) -> Variant:
	return _value[_iter_current_index]


func _iter_should_continue() -> bool:
	return _iter_current_index < size()

	
func append(item: Variant) -> void:
	_value.append(item)
	value_changed.emit(Type.UPDATED, _value, item)
	
	
func append_array(items: Array) -> void:
	_value.append_array(items)
	value_changed.emit(Type.UPDATED_LIST, _value, items)
	

func assign(items: Array) -> void:
	_value.assign(items)
	value_changed.emit(Type.UPDATED_LIST, _value, items)
	
	
func clear() -> void:
	_value.clear()
	value_changed.emit(Type.CLEARED, _value, null)
	
	
func erase(item: Variant) -> void:
	_value.erase(item)
	value_changed.emit(Type.ERASED, _value, item)
	
	
func fill(item: Variant) -> void:
	_value.fill(item)
	value_changed.emit(Type.UPDATED_LIST, _value, _value)


func get_index(position: int) -> Variant:
	return _value[position]


func has(item: Variant) -> bool:
	return _value.has(item)

	
func insert(position: int, item: Variant) -> void:
	_value.insert(position, item)
	value_changed.emit(Type.UPDATED, _value, item)
	
	
func pop_at(index: int) -> Variant:
	var item = _value.pop_at(index)
	value_changed.emit(Type.ERASED, _value, item)
	return item
	
	
func pop_back() -> Variant:
	var item = _value.pop_back()
	value_changed.emit(Type.ERASED, _value, item)
	return item
	
	
func pop_front() -> Variant:
	var item = _value.pop_front()
	value_changed.emit(Type.ERASED, _value, item)
	return item
	
	
func push_back(item: Variant) -> void:
	_value.push_back(item)
	value_changed.emit(Type.UPDATED, _value, item)
	
	
func push_front(item: Variant) -> void:
	_value.push_back(item)
	value_changed.emit(Type.UPDATED, _value, item)
	
	
func remove_at(position: int) -> void:
	var item = _value[position]
	_value.remove_at(position)
	value_changed.emit(Type.ERASED, _value, item)
	
	
func set_index(position: int, item: Variant) -> void:
	_value[position] = item
	value_changed.emit(Type.UPDATED, _value, item)
	
	
func size() -> int:
	return _value.size()


## Observes every type of event with [enum Type] in the [SxArrayProperty].
## [b]emit_initial_value[/b] can be set to false to not emit current value on subscription.
## Returns [SxSignal](Type, array, payload).	
func as_signal(emit_initial_value := true) -> SxSignal:
	var result := Sx.from(value_changed)
	if emit_initial_value:
		result = result.start_with(func(): return [Type.UPDATED_LIST, _value, _value])
	return result
	

## Observes specific event with [enum Type]
## [b]emit_initial_value[/b] can be set to false to not emit current value on subscription.
## Returns [SxSignal](array, payload).
func observe(event: Type, emit_initial_value := true) -> SxSignal:
	return as_signal(emit_initial_value).filter(func(type: Type, _y, _z): return type == event) \
		.map(func(_x, array: Array, payload: Variant): return [array, payload])
