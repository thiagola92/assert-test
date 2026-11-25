class_name AssertFilterStart
extends AssertFilter


@export var starting_with: Array[String] = [
	" ",
	"\t",
]


func apply(text: String) -> String:
	if text.is_empty():
		return text
	
	var parts: PackedStringArray = text.split("\n")
	
	# Walk backward so we can remove at any moment.
	for i in range(parts.size() - 1, -1, -1):
		for start in starting_with:
			if parts.get(i).begins_with(start):
				parts.remove_at(i)
				break
	
	return "\n".join(parts)
