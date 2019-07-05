Extension { #name : #TostMaterialization }

{ #category : #'*Seamless' }
TostMaterialization >> readSeamlessReference: anObjectReference [
	^transporter readObjectReference: anObjectReference with: self
]

{ #category : #'*Seamless' }
TostMaterialization >> readSeamlessSubstitution [

	| loadedObjectIndex loadedObject localRepresentation |
	loadedObjectIndex := objectIndex.
	loadedObject := self readObject.

	localRepresentation := transporter prepareLocalSubstitutionOf: loadedObject with: self.
	localRepresentation == loadedObject ifTrue: [ ^loadedObject  ].
	
	processedObjects at: loadedObjectIndex put: localRepresentation.
	
	^localRepresentation
]
