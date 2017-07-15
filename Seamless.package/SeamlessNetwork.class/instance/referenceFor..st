accessing
referenceFor: anObject

	^self referenceFor: anObject ifNewUse: [ anObject createSeamlessReference]