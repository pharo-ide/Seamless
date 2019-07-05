"
I represent some missing local global which should be there for received well known object.
I am created by SeamlessWellKnownObject for local representation when actual global is not exist.
When I am transferred back to client I am materialized again with original global object.

Internal Representation and Key Implementation Points.

    Instance Variables
	name:		<String>
"
Class {
	#name : #SeamlessMissingGlobal,
	#superclass : #SeamlessTransferObject,
	#instVars : [
		'name'
	],
	#category : 'Seamless-Core'
}

{ #category : #'instance creation' }
SeamlessMissingGlobal class >> named: aString [
	^self new 
		name: aString
]

{ #category : #accessing }
SeamlessMissingGlobal >> name [
	^ name
]

{ #category : #accessing }
SeamlessMissingGlobal >> name: anObject [
	name := anObject
]

{ #category : #printing }
SeamlessMissingGlobal >> printOn: aStream [
	super printOn: aStream.
	aStream nextPut: $(.
	aStream nextPutAll: name.
	aStream nextPut: $).
]

{ #category : #'transfer strategies' }
SeamlessMissingGlobal >> seamlessDefaultTransferStrategy [ 

	^SeamlessTransferStrategy defaultByGlobalName 
]
