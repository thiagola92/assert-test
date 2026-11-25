class_name AssertFilter
extends Resource


## Receives text from stderr and apply changes to it.
## WARNING: There is no guarantee that every text is a line,
## you could receive part of a line or even more than one line.
func apply(text: String) -> String:
	return text
