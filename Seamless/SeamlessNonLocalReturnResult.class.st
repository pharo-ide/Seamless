"
I represent non local return to remote side which was happened during remote message send.

SeamlessMessageSendRequest catches BlockCannotReturn and return me as execution result with target home context and returned value. 
On sender side I check that home context is local object and not proxy. And if it is true I return given value from home context which completes not local return. 
Otherwise I signal original BlockCannotReturn error which will pass non local return to next remote sender
  
Internal Representation and Key Implementation Points.

    Instance Variables
	homeContext:		<Context>
	value:		<Object>
"
Class {
	#name : #SeamlessNonLocalReturnResult,
	#superclass : #SeamlessRequestResult,
	#instVars : [
		'homeContext',
		'value'
	],
	#category : 'Seamless-Requests'
}

{ #category : #'instance creation' }
SeamlessNonLocalReturnResult class >> with: anObject homeContext: aContext [
	^self new 
		value: anObject;
		homeContext: aContext
]

{ #category : #accessing }
SeamlessNonLocalReturnResult >> homeContext [
	^ homeContext
]

{ #category : #accessing }
SeamlessNonLocalReturnResult >> homeContext: anObject [
	homeContext := anObject
]

{ #category : #accessing }
SeamlessNonLocalReturnResult >> returnValue [
	homeContext isSeamlessProxy ifTrue: [ 
		^BlockCannotReturn result: value from: homeContext].

	homeContext return: value
]

{ #category : #accessing }
SeamlessNonLocalReturnResult >> value [
	^value
]

{ #category : #accessing }
SeamlessNonLocalReturnResult >> value: anObject [
	value := anObject
]
