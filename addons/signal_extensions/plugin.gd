@tool
extends EditorPlugin


const PLUGIN_NAME := "Sx"


func _enter_tree() -> void:
	add_autoload_singleton(PLUGIN_NAME, "res://addons/signal_extensions/sx_autoload.gd")


func _exit_tree() -> void:
	remove_autoload_singleton(PLUGIN_NAME)
