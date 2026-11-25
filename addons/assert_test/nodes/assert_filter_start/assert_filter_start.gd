class_name AssertFilterStart
extends AssertFilter


## Remove lines starting with these strings.
@export var starting_with: Array[String] = [
	" ",
	"\t",
]

var _is_newline: bool = true


func apply(text: String) -> String:
	if text.is_empty():
		return text
	
	var parts: PackedStringArray = text.split("\n")
	
	# We need to know if we were in the middle of a sentence to not risking filtering it.
	var stop: int = -1 if _is_newline else 0
	_is_newline = text.ends_with("\n")
	
	# Walk backward so we can remove at any moment.
	for i in range(parts.size() - 1, stop, -1):
		for start in starting_with:
			if parts.get(i).begins_with(start):
				parts.remove_at(i)
				break
	
	return "\n".join(parts)
