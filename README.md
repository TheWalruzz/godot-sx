# GodotSx - Signal Extensions for Godot 4

Have you ever wanted to do more things with Godot's signals? Maybe merge them or filter them Rx-style?
Then Signal Extensions (or Sx for short) are for you. This simple and lightweight library allows you to do basic operations on regular Signals
and treat them like reactive-ish streams. 

*DISCLAIMER: This addon is NOT an Rx implementation. Therefore, it does not, nor will it ever, implement all the functionality and operators of Rx.
If you need a proper Rx implementation for Godot 4, see this excellent project: [GodotRx](https://github.com/Neroware/GodotRx) that Sx is largely inspired by.*

## Motivation
The main goal of this library is to allow for more advanced signal handling in Godot.

Godot's built-in signal system is robust, but could really profit from reactive approach, which works pretty well with games. Especially when a lot of components interact with each other.

Those kind of manipulations could be done by an Rx framework (like GodotRx mentioned above), but this means including a package, that due to the sheer scale of mechanisms needed for pure Rx to work, is really big and bloated for use cases you might actually encounter in your code.

Instead of including a big and complex Rx solution, why not extend the existing mechanism?

Sx allows for signal manipulation that feels like Rx, without all the overhead.

## Installation
* Copy `addons/signal_extensions` directory to the `/addons/` directory in your project
* Enable `SignalExtensions` plugin in Project Settings -> Plugins
* You're done! You now have access to Sx singleton!


## Basic usage
In order to perform operations on signals, they have to be converted to SxSignal:
	
```gdscript
signal my_signal

var my_wrapped_signal := Sx.from(my_signal)
```

### Subscription
To subscribe to emissions, use `.subscribe(Callable)`:
	
```gdscript
signal my_signal

Sx.from(my_signal).subscribe(func(): print("Got it!"))
my_signal.emit()

# result:
# 	Got it!
```

Much like when connecting to native signals, some flags can be passed to control the signal connection. See: enum Object.ConnectFlags.
Please note that using *CONNECT_ONE_SHOT* might break the subscription system of GodotSx. Use *.first()* operator instead.

```gdscript
signal my_signal

# this will defer emissions to idle frame, instead of sending them immediately.
Sx.from(my_signal).subscribe(func(): pass, CONNECT_DEFERRED)
```

### Filtering and mapping
You can filter and map emitted items much like in regular Rx implementations:

```gdscript
signal value_changed(int)

# multiply only positive numbers by 2
Sx.from(value_changed) \
	.filter(func(value: int): return value > 0) \
	.map(func(value: int): return value * 2) \
	.subscribe(func(value: int): print(value))

value_changed.emit(-2)
value_changed.emit(-1)
value_changed.emit(0)
value_changed.emit(1)
value_changed.emit(2)

# result:
# 	2
# 	4
```

Sx supports signals with up to 6 arguments and they can also be filtered and mapped:

```gdscript
signal multi_values(int, int2)

# when mapping multiple values, array must be returned from lambda
Sx.from(multi_values) \
	.filter(func(value1: int, value2: int): return value2 > value1) \
	.map(func(value1: int, value2: int): return [value2, value1]) \
	.subscribe(func(value1: int, value2: int): print(value1, " ", value2))

multi_values.emit(2, 1)	
multi_values.emit(3, 10)

# result:
#	10 3
```

Number of arguments down the chain can be freely changed using map:

```gdscript
signal int_values(int)

Sx.from(int_values) \
	.map(func(value: int): return [value, value * 2]) \
	.subscribe(func(value1: int, value2: int): print(value1, " ", value2))
	
int_values.emit(3)

# result:
#	3 6
```

### Merging signals
Multiple Godot signals can be merged into one using `Sx.merge_from()`:

```gdscript
signal signal1(int)
signal signal2(int)

Sx.merge_from([signal1, signal2]).subscribe(func(value: int): print(value))
signal1.emit(1)
signal2.emit(2)

# result:
#	1
#	2
```

Multiple SxSignals can also be merged easily using `Sx.merge()`:

```gdscript
signal signal1(int)
signal signal2(int)

Sx.merge([
	Sx.from(signal1).map(func(value: int): return value * 2),
	Sx.from(signal2).map(func(value: int): return value * 3)
]).subscribe(func(value: int): print(value))
signal1.emit(1)
signal2.emit(2)

# result:
#	2
#	6
```

### Timers
To simplify creation of periodic interval timers (without the hassle of creating and managing a Timer node yourself),
you can use `Sx.interval_timer()` to create a SxSignal that will periodically emit items.

```gdscript
Sx.interval_timer(1.0).subscribe(func(): print("Tick!"))
# prints 'Tick!' every second
```

`interval_timer()` also accepts optional parameters to control the process mode and process callback of the timer.
To see more information about what they do, check Godot docs about Node and Timer respectively.

```gdscript
Sx.interval_timer(
	1.0,
	Node.PROCESS_MODE_ALWAYS,
	Timer.TIMER_PROCESS_PHYSICS
).subscribe(func(): print("Tick!"))
```

This Timer will automatically destroy itself once all the subscriptions are disposed.

Creation of one-shot timers this way is not supported, but you can just do:

```gdscript
Sx.from(get_tree().create_timer(1.0).timeout).subscribe(func(): print("Timeout!"))
```

### On complete callback
When you're subscribing, you can set an optional callback that will be fired when the signal completes (either naturally, or when signal is disposed).

```gdscript
signal numbers(int)

Sx.from(numbers).first().subscribe(
	func(value: int): print(value),
	0, # no connect flags
	func(): print("Completed")
)
numbers.emit(5)

# result:
#	5
#	Completed
```

Or:
	
```gdscript
signal numbers(int)

var disposable := Sx.from(numbers).subscribe(
	func(value: int): print(value),
	0, # no connect flags
	func(): print("Completed")
)
numbers.emit(5)
disposable.dispose()

# result:
#	5
#	Completed
```

### Subscription disposal
Signals can dispose themselves (and disconnect from signals) when some of operators are used. These include:
* take_while
* take
* element_at
* first

When they finish their emissions, they dispose themselves according to the operator used.

```gdscript
signal numbers(value)


Sx.from(numbers).take_while(func(value: int): return value < 0) \
	.subscribe(
		func(value: int): print(value),
		0, # no connect flags
		func(): print("Completed")
)
numbers.emit(-2)
numbers.emit(-1)
numbers.emit(0)
numbers.emit(1)
numbers.emit(2)

# result:
#	-2
#	-1
#	Completed
```

```gdscript
signal numbers(value)


Sx.from(numbers).first().subscribe(
		func(value: int): print(value),
		0, # no connect flags
		func(): print("Completed")
)
numbers.emit(-2)
numbers.emit(-1)
numbers.emit(0)
numbers.emit(1)
numbers.emit(2)

# result:
#	-2
#	Completed
```

You might want to dispose SxSignals manually, or automatically when the subscribing Node exits the tree (both of which are highly recommended to make sure no accidental memory leaks occur).
`subscribe()` method returns a SxDisposable object which allows for:
* manual subscription disposal (and subsequent disconnection from signal) using `dispose()`
* automatic disposal when Node is exitting the scene tree using `dispose_with(Node)`
* adding disposable to SxCompositeDisposable using `dispose_with(SxCompositeDisposable)`

```gdscript
extends Node

func _ready() -> void:
	Sx.from(some_other_node.my_signal).subscribe(func(): pass).dispose_with(self)
```

Composite disposable:
	
```gdscript
signal test_signal

var composite_disposable := SxCompositeDisposable.new()
Sx.from(test_signal).subscribe(func(): print("First subscription")).dispose_with(composite_disposable)
Sx.from(test_signal).subscribe(func(): print("Second subscription")).dispose_with(composite_disposable)
composite_disposable.dispose()
```

Disposables can also be added to a SxCompositeDisposable directly:

```gdscript
signal some_signal

var composite_disposable := SxCompositeDisposable.new()
var disposable := Sx.from(some_signal).subscribe(func(): pass)
composite_disposable.append(disposable)
composite_disposable.dispose()
```

### Signal-based properties
Sometimes, you need to store some values and react when they change. For this reason, Sx provides it's own implementation of Signal-based values, much like ReactiveProperties in GodotRx and UniRx.

```gdscript
var property := SxProperty.new(10)
property.as_signal().subscribe(func(value: int): print(value))
property.value = 15

# result:
#	10
#	15
```

You can also directly access the underlying signal:

```gdscript
property.value_changed.connect(func(value: int): print(value))
```

Also, in case you don't want the initial emission when subscribing to SxProperty, you can pass false to `as_signal()`:
	
```gdscript
var property := SxProperty.new(10)
property.as_signal(false).subscribe(func(value: int): print(value))
property.value = 15

# result:
#	15
```

There are also wrappers around Array and Dictionary, called SxArrayProperty and SxDictionaryProperty, but they're more complex.
For starters, all operations that result in count of items change, should be processed by the Sx wrapper, but everything else, 
like filtering, and mapping items is allowed only through special getter *.value* which returns the underlying Array or Dictionary.

```gdscript
var array := SxArrayProperty.new()
array.as_signal().subscribe(func(type: SxArrayProperty.Type, current_array: Array, payload: Variant):
	print(type, current_array, payload)
)
array.append(2)

# result:
#	SxArrayProperty.Type.UPDATED_LIST [] []
#	SxArrayProperty.Type.UPDATED [2] 2
#	SxArrayProperty.Type.COUNT_CHANGED [2] 1
```

```gdscript
var dict := SxDictionaryProperty.new()
dict.as_signal().subscribe(func(type: SxDictionaryProperty.Type, current: Dictionary, payload: Variant):
	print(type, current, payload)
)
dict.set_value("test", 2)

# result:
#	SxDictionaryProperty.Type.UPDATED_LIST {} {}
#	SxDictionaryProperty.Type.UPDATED {"test":2} "test"
#	SxDictionaryProperty.Type.COUNT_CHANGED {"test":2} 1
```

When getting the underlying value, use *.value* or *.get_index()*/*.get_value()*

```gdscript
var array := SxArrayProperty.new([1])
print(array.value[0])
print(array.get_index(0))

# result:
#	1
#	1
```

To observe specific events:
	
```gdscript
var array := SxArrayProperty.new([1])
array.observe(SxArrayProperty.Type.UPDATED).subscribe(func(current_array: Array, payload: Variant):
	print(current_array, payload)
)
```

Both *.as_signal()* and *.observe()* can take an optional bool argument *emit_initial_value* which can be set to false.
Doing so will not emit the current state when subscribing:

```gdscript
var dict := SxDictionaryProperty.new()
dict.as_signal(false).subscribe(func(type: SxDictionaryProperty.Type, current: Dictionary, payload: Variant):
	print(type, current, payload)
)
dict.set_value("test", 2)

# result:
#	SxDictionaryProperty.Type.UPDATED {"test":2} "test"
#	SxDictionaryProperty.Type.COUNT_CHANGED {"test":2} 1
```

Both SxArrayProperty and SxDictionaryProperty implement custom iterators, so they can iterated on in for loops:

```gdscript
var array := SxArrayProperty.new([10, 20, 30])
for item in array:
	print(item)
	
# result:
#	10
#	20
#	30
```

```gdscript
var dict := SxDictionaryProperty.new({test1 = 1, test2 = 2})
for key in dict:
	print(key)
	
# result:
#	test1
#	test2
```

### All available operators
* delay
* element_at
* filter
* first
* map
* merge
* merge_from
* skip
* skip_while
* start_with
* take
* take_while

Please note that full implementation of all Rx operators is NOT a goal of this library.
If you have a more complex problem that cannot be solved with Sx, then use GodotRx instead.

# License
Distributed under the [MIT License](https://github.com/TheWalruzz/godot-sx/blob/main/LICENSE).
