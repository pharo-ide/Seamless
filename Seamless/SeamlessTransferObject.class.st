"
I am root class for objects which are used for transfer and substitute other normal object.

I define that my subclasses should always and only transferred by value
"
Class {
	#name : #SeamlessTransferObject,
	#superclass : #Object,
	#category : 'Seamless-Core'
}

{ #category : #testing }
SeamlessTransferObject class >> definesWellKnownSeamlessClass [
	^true
]

{ #category : #testing }
SeamlessTransferObject class >> definesWellKnownSeamlessClassHierarchy [ 
	^true
]

{ #category : #testing }
SeamlessTransferObject >> isOnlyDefaultTransferStrategyAllowed [
	^true
]

{ #category : #accessing }
SeamlessTransferObject >> seamlessDefaultTransferStrategy [ 
	^SeamlessTransferStrategy defaultByValue 
]
