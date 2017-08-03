code generation
write: anObject
	super write: anObject.
	state value: anObject.
	^anObject