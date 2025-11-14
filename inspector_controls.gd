@tool
extends EditorInspectorPlugin

var editor_plugin: EditorPlugin

func _can_handle(obj):
	# Only handle AnimationPlayer nodes
	if obj is AnimationPlayer:
		return true
	return false

## Create UI at the end of the inspector
func _parse_end(obj: Object):
	if not obj is AnimationPlayer:
		return

	var header = CustomEditorInspectorCategory.new("Shift All Keyframe Values")

	# Create the shift controls
	var shift_container = VBoxContainer.new()

	# Shift amount input
	var shift_label = Label.new()
	shift_label.text = "Shift Amount (integer):"
	shift_container.add_child(shift_label)

	var shift_input = SpinBox.new()
	shift_input.name = "ShiftInput"
	shift_input.min_value = -10000
	shift_input.max_value = 10000
	shift_input.step = 1
	shift_input.rounded = true
	shift_input.allow_greater = true
	shift_input.allow_lesser = true
	shift_input.value = 0
	shift_input.custom_minimum_size = Vector2(0, 26)
	shift_container.add_child(shift_input)

	# Shift button
	var shift_button := Button.new()
	shift_button.text = "Apply"
	shift_button.custom_minimum_size = Vector2(0, 32)
	shift_button.pressed.connect(_on_shift_button_pressed.bind(shift_input, obj))

	var button_style = StyleBoxFlat.new()
	button_style.bg_color = Color(32.0/255.0, 37.0/255.0, 49.0/255.0)
	shift_button.add_theme_stylebox_override("normal", button_style)

	shift_container.add_child(shift_button)

	# Add everything to inspector
	var container = VBoxContainer.new()
	container.add_child(header)
	container.add_child(shift_container)

	add_custom_control(container)

func _on_shift_button_pressed(shift_input: SpinBox, anim_player: AnimationPlayer):
	print("[AnimationKeyShifter] === Shift button pressed ===")
	var shift_amount = int(shift_input.value)
	print("[AnimationKeyShifter] Shift amount: %d" % shift_amount)

	if shift_amount == 0:
		print("[AnimationKeyShifter] Shift amount is 0, no changes made")
		return

	# Get the current animation from the AnimationPlayer
	var current_anim_name = anim_player.current_animation
	print("[AnimationKeyShifter] Current animation property: '%s'" % current_anim_name)

	# If no animation is set, try to find one
	if current_anim_name == "":
		var anim_list = anim_player.get_animation_list()
		print("[AnimationKeyShifter] Available animations: %s" % anim_list)

		if anim_list.size() == 0:
			print("[AnimationKeyShifter] ERROR: No animations found in AnimationPlayer")
			return

		# Use the first animation
		current_anim_name = anim_list[0]
		print("[AnimationKeyShifter] Using first animation: '%s'" % current_anim_name)

	var animation = anim_player.get_animation(current_anim_name)
	if not animation:
		print("[AnimationKeyShifter] ERROR: Could not get animation '%s'" % current_anim_name)
		return

	print("[AnimationKeyShifter] Animation '%s' has %d tracks" % [current_anim_name, animation.get_track_count()])

	# Get the undo/redo from the editor plugin
	var undo_redo = editor_plugin.get_undo_redo()
	undo_redo.create_action("Shift Animation Key Values")

	var total_shifted = 0

	# Iterate through all tracks
	for track_idx in range(animation.get_track_count()):
		var track_type = animation.track_get_type(track_idx)

		# Only process value tracks (numeric values)
		if track_type == Animation.TYPE_VALUE:
			var key_count = animation.track_get_key_count(track_idx)

			# Process each key in the track
			for key_idx in range(key_count):
				var current_value = animation.track_get_key_value(track_idx, key_idx)

				# Check if value is numeric (int or float)
				if current_value is float or current_value is int:
					var new_value = current_value + shift_amount

					# Record undo/redo
					undo_redo.add_do_method(animation, "track_set_key_value", track_idx, key_idx, new_value)
					undo_redo.add_undo_method(animation, "track_set_key_value", track_idx, key_idx, current_value)

					total_shifted += 1

	undo_redo.commit_action()

	print("[AnimationKeyShifter] Successfully shifted %d keyframes by %d in animation '%s'" % [total_shifted, shift_amount, current_anim_name])

# Child class for header
class CustomEditorInspectorCategory extends Control:
	var title: String = ""
	var icon: Texture2D = null

	func _init(p_title: String, p_icon: Texture2D = null):
		title = p_title
		icon = p_icon
		tooltip_text = "Shifts ALL numeric keyframe values by the specified \"Shift Amount\", \nfor the \"Current Animation\" selected in the AnimationPlayer inspector \n (not what is selected in the Animation Bottom Panel)"

	func _get_minimum_size() -> Vector2:
		var font := get_theme_font(&"bold", &"EditorFonts")
		var font_size := get_theme_font_size(&"bold_size", &"EditorFonts")

		var ms: Vector2
		ms.y = font.get_height(font_size)
		if icon:
			ms.y = max(icon.get_height(), ms.y)

		ms.y += get_theme_constant(&"v_separation", &"Tree")

		return ms

	func _draw() -> void:
		var sb := get_theme_stylebox(&"bg", &"EditorInspectorCategory")
		draw_style_box(sb, Rect2(Vector2.ZERO, size))

		var font := get_theme_font(&"bold", &"EditorFonts")
		var font_size := get_theme_font_size(&"bold_size", &"EditorFonts")

		var hs := get_theme_constant(&"h_separation", &"Tree")

		var w: int = font.get_string_size(title, HORIZONTAL_ALIGNMENT_LEFT, -1, font_size).x
		if icon:
			w += hs + icon.get_width()

		var ofs := (get_size().x - w) / 2

		if icon:
			draw_texture(icon, Vector2(ofs, (get_size().y - icon.get_height()) / 2).floor())
			ofs += hs + icon.get_width()

		var color := get_theme_color(&"font_color", &"Tree")
		draw_string(font, Vector2(ofs, font.get_ascent(font_size) + (get_size().y - font.get_height(font_size)) / 2).floor(), title, HORIZONTAL_ALIGNMENT_LEFT, get_size().x, font_size, color)
