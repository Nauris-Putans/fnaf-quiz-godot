extends Label

class_name AutoFitLabel

@export var max_font_size: int = 32
@export var min_font_size: int = 14
@export var padding: Vector2 = Vector2(16, 16) # x = left+right, y = top+bottom


func _ready() -> void:
	refit()


func _notification(what: int) -> void:
	if what == NOTIFICATION_RESIZED or what == NOTIFICATION_THEME_CHANGED:
		refit()


func set_fit_text(value: String) -> void:
	text = value
	refit()


func refit() -> void:
	var font: Font = get_theme_font("font")
	if font == null:
		return

	var target_w: float = max(0.0, size.x - padding.x)
	var target_h: float = max(0.0, size.y - padding.y)

	var best: int = min_font_size
	var lo: int = min_font_size
	var hi: int = max_font_size

	var align: HorizontalAlignment = horizontal_alignment

	while lo <= hi:
		var mid: int = int((lo + hi) / 2)

		var measured: Vector2 = font.get_multiline_string_size(
			text,
			align,
			target_w,
			mid,
		)

		if measured.x <= target_w and measured.y <= target_h:
			best = mid
			lo = mid + 1
		else:
			hi = mid - 1

	add_theme_font_size_override("font_size", best)
