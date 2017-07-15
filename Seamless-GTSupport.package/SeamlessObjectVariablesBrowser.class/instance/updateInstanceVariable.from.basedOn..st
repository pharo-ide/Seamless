private building
updateInstanceVariable: aSymbol from: anObject basedOn: aString
	|result|

	(anObject remoteClass hasInstVarNamed: aSymbol) 
		ifFalse: [ ^ self ].
	result := anObject remoteClass compiler
			source: aString;
			context: nil;
			receiver: anObject;
			failBlock: [ ^ self ];
			evaluate.

	anObject writeSlotNamed: aSymbol value: result.
	