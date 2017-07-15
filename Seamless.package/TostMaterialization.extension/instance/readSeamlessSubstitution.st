*Seamless
readSeamlessSubstitution

	| loadedObjectIndex loadedObject localRepresentation |
	loadedObjectIndex := objectIndex.
	loadedObject := self readObject.

	localRepresentation := transporter prepareLocalSubstitutionOf: loadedObject with: self.
	localRepresentation == loadedObject ifTrue: [ ^loadedObject  ].
	
	processedObjects at: loadedObjectIndex put: localRepresentation.
	
	^localRepresentation