testing
isAppliedTo: anObject
	criteria ifNil: [ ^false ].
	
	^criteria matches: anObject