extends RefCounted
class_name SxDictionaryProperty


enum Event {
	UPDATED_LIST,
	UPDATED,
	ERASED,
	CLEARED,
	COUNT_CHANGED,
}


signal value_changed(type, array, payload)


var value: Dictionary = {}:
	get: return value
	
var _last_size := 0
var _iter_current_index := 0
var _iter_keys := []
	

func _init(initial_value: Dictionary = {}):
	value = initial_value
	_last_size = value.size()
	
	Sx.from(value_changed).filter(func(type: Event, dict: Dictionary, _z):
		return type != Event.COUNT_CHANGED and _last_size != dict.size()
	).subscribe(func(_x, dict: Dictionary, _z): 
		value_changed.emit(Event.COUNT_CHANGED, dict, dict.size())
		_last_size = dict.size()
	)


func _iter_init(_arg) -> bool:
	_iter_keys = keys()
	_iter_current_index = 0
	return _iter_should_continue()


func _iter_next(_arg) -> bool:
	_iter_current_index += 1
	return _iter_should_continue()


func _iter_get(_arg) -> Variant:
	return value[_iter_keys[_iter_current_index]]


func _iter_should_continue() -> bool:
	return _iter_current_index < size()

	
func clear() -> void:
	value.clear()
	value_changed.emit(Event.CLEARED, value, null)
	
	
func erase(item: Variant) -> void:
	value.erase(item)
	value_changed.emit(Event.ERASED, value, item)


func get_value(key: Variant, default: Variant = null) -> Variant:
	if not has(key):
		return default
	return value[key]
	
	
func has(item: Variant) -> bool:
	return value.has(item)
	
	
func keys() -> Array:
	return value.keys()
	
	
func merge(dictionary: Dictionary, overwrite: bool = false) -> void:
	value.merge(dictionary, overwrite)
	value_changed.emit(Event.UPDATED_LIST, value, dictionary)
	
	
	
func set_value(key: Variant, item: Variant) -> void:
	value[key] = item
	value_changed.emit(Event.UPDATED, value, key)
	
	
func size() -> int:
	return value.size()
	
	
func values() -> Array:
	return value.values()
	

## Observes every type of event with [enum Event] in the [SxDictionaryProperty].
## [b]emit_initial_value[/b] can be set to false to not emit current value on subscription.
## Returns [SxSignal](Event, dictionary, payload).
func as_signal(emit_initial_value := true) -> SxSignal:
	var result := Sx.from(value_changed)
	if emit_initial_value:
		result = result.start_with(func(): return [Event.UPDATED_LIST, value, value])
	return result
	

## Observes specific event with [enum Event]
## Returns [SxSignal](dictionary, payload).
func observe(event: Event) -> SxSignal:
	return as_signal().filter(func(type: Event, _y, _z): return type == event) \
		.map(func(_x, dict: Dictionary, payload: Variant): return [dict, payload])

