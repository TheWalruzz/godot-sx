@tool
extends EditorPlugin

const AUTOLOAD_NAME := "Sx"


func _enter_tree() -> void:
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/signal_extensions/signal_extensions.gd")


func _exit_tree() -> void:
	remove_autoload_singleton(AUTOLOAD_NAME)
