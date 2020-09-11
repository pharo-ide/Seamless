"
I represent well known global object by name. I used to represent globals (classes) on remote side as existing globals with same name.
 
I override normal object serialization to provide more compact binary format.
So I implement custom writeTostBodyWith: method instead of walking by my vars with travel guide. And in binary form I am just a string
	
Internal Representation and Key Implementation Points.

    Instance Variables
	name:		<String>
"
Class {
	#name : #SeamlessWellKnownObject,
	#superclass : #SeamlessTransferObject,
	#instVars : [
		'name'
	],
	#category : 'Seamless-Core'
}

{ #category : #transfer }
SeamlessWellKnownObject class >> createTostInstanceWith: aSeamlessTransporter [
	| instance |
	instance := super createTostInstanceWith: aSeamlessTransporter.
	instance name: (Symbol createTostInstanceWith: aSeamlessTransporter).
	^instance
]

{ #category : #'instance creation' }
SeamlessWellKnownObject class >> named: aString [
	^self new 
		name: aString
]

{ #category : #accessing }
SeamlessWellKnownObject >> name [
	^ name
]

{ #category : #accessing }
SeamlessWellKnownObject >> name: anObject [
	name := anObject
]

{ #category : #transfer }
SeamlessWellKnownObject >> prepareLocalSubstitutionIn: aSeamlessNetwork with: aTostMaterialization [

	| global  |
	global := self class environment at: name ifAbsent: [SeamlessMissingGlobal named: name].
	aTostMaterialization skip: global.
	^global 
]

{ #category : #transfer }
SeamlessWellKnownObject >> travelGuide [
	"I override normal objects serialization to provide more compact binary format.
	So I implement custom writeTostBodyWith: method instead of walking by my state by travel guide"
	^ EmptyObjectTravelGuide 
]

{ #category : #transfer }
SeamlessWellKnownObject >> writeTostBodyWith: aSeamlessTransporter [
	
	aSeamlessTransporter writeString: name
	
]
