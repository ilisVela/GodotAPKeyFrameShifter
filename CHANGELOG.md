# Changelog

All notable changes to the AnimationPlayer KeyFrame Shifter plugin will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2025-11-14

### Added
- Animation selection dropdown in inspector UI
- Explicit animation selector that works independently of AnimationPlayer's current_animation property

### Changed
- Replaced reliance on AnimationPlayer's `current_animation` property with dropdown selection
- Updated UI to include "Select Animation:" label and OptionButton control
- Improved compatibility with local/unique AnimationPlayer instances

### Fixed
- Fixed issue where plugin wouldn't work with locally instanced AnimationPlayer nodes
- Fixed problem where `current_animation` property was empty during scene editing

## [1.0.0] - 2025-11-14

### Added
- Initial release of AnimationPlayer KeyFrame Shifter
- Batch shift all numeric keyframe values in an animation
- Undo/Redo support for all shift operations
- Custom inspector controls for AnimationPlayer nodes
- Support for both integer and float keyframe values
- Direct animation track manipulation to bypass inspector limitations
- Comprehensive README with usage instructions
- MIT License
