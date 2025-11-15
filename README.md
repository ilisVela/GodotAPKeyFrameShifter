# AnimationPlayer KeyFrame Shifter

A Godot 4.x editor plugin that allows you to batch shift animation keyframe values while preserving their relative offsets - something the default Godot inspector cannot do.

## Features

- **Batch Shift Keyframe Values**: Apply numeric offsets to all keyframes in an animation while preserving each keyframe's individual value
- **Undo/Redo Support**: Full integration with Godot's undo/redo system for safe editing
- **Direct Track Access**: Bypasses inspector limitations by working directly with animation track data
- **Preserves Relative Values**: Shifting keyframes with values `[0, 1, 2]` by `+12` results in `[12, 13, 14]` instead of overwriting all to a single value
- **Works with Any Numeric Values**: Supports both integer and float keyframe values (sprite frames, positions, scales, etc.)

## Installation

### From Asset Library
1. Open Godot Editor
2. Go to AssetLib tab
3. Search for "AnimationPlayer KeyFrame Shifter"
4. Click Download → Install
5. Enable the plugin in Project Settings → Plugins

### Manual Installation
1. Copy the `addons/APKeyFrameShifter` folder into your project's `addons/` directory
2. Enable the plugin in Project Settings → Plugins

## Usage

1. Select an `AnimationPlayer` node in your scene
2. In the Inspector, scroll to the bottom to find the "Shift All Keyframe Values" section
3. Use the "Select Animation:" dropdown to choose which animation to modify
4. Enter a shift amount (positive or negative integer)
5. Click "Apply" to shift all numeric keyframes in the selected animation

**Note**: The dropdown will automatically select the current animation if one is set in the AnimationPlayer, but you can choose any animation from the list.

## The Problem This Solves

Godot's built-in `AnimationMultiTrackKeyEdit` system has a limitation: when you select multiple keyframes, it only stores a single value and overwrites all selected keyframes with that value. This makes it impossible to batch shift sprite frame indices or other sequential values.

### Without This Plugin

To shift sprite frames from `[0, 1, 2, 3, 4]` to `[10, 11, 12, 13, 14]`, you must:
- Manually edit each keyframe one at a time, OR
- Use a tedious workaround with select/deselect/increment cycles

### With This Plugin

Simply enter `+10` as the shift amount and click Apply. All keyframes are shifted while preserving their relative offsets.

## How It Works

The plugin works around the inspector limitation by:
1. Reading keyframe values directly from animation tracks via the AnimationPlayer API
2. Applying the offset to each individual keyframe value
3. Updating the tracks with the new values while preserving all timing and other properties

## Technical Details

- **Godot Version**: 4.x
- **License**: MIT
- **Language**: GDScript
- **Plugin Type**: Editor Inspector Plugin

## Use Cases

- Shifting sprite frame indices when reordering sprite sheets
- Adjusting animation timings or positions en masse
- Offsetting numeric properties across entire animations
- Any scenario requiring batch mathematical operations on keyframe values

## Support & Contributing

Report issues and contribute at: https://github.com/ilisVela/APKeyFrameShifter

## License

MIT License - See [LICENSE](LICENSE) file for details
