class_name AssertFilter
extends Resource
## Apply a filter to the text coming from stderr.

## Apply changes to a text.
## [br][br]
## [b]Note[/b]: When receiving text from stderr, there is no guarantee
## that every text is a line, you could receive part of a line
## or even more than one line.
func apply(text: String) -> String:
	return text
