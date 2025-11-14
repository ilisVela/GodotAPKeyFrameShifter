@tool
extends EditorPlugin

const InspectorControls = preload("./inspector_controls.gd")

var inspector_plugin: InspectorControls

func _enter_tree():
	inspector_plugin = InspectorControls.new()
	inspector_plugin.editor_plugin = self
	add_inspector_plugin(inspector_plugin)
	print("[AnimationKeyShifter] Plugin loaded successfully")

func _exit_tree():
	remove_inspector_plugin(inspector_plugin)
