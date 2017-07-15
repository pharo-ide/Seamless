private building
tagsForVariable: aString from: aContext
	^ (#( 'self' 'thisContext' 'stack top') includes: aString) 
		ifTrue: [ 'implicit' ]
		ifFalse: [ self variableTypeOf: aString in: aContext ]