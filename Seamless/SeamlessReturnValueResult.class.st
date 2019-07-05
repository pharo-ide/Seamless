"
I represent simple resulted object which should be returned to request sender as execution result.

SeamlessMessageSendRequest uses me to return result of message send.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	value:		<Object>
"
Class {
	#name : #SeamlessReturnValueResult,
	#superclass : #SeamlessRequestResult,
	#instVars : [
		'value'
	],
	#category : 'Seamless-Requests'
}

{ #category : #'instance creation' }
SeamlessReturnValueResult class >> with: anObject [ 
	^self new 
		value: anObject
]

{ #category : #evaluating }
SeamlessReturnValueResult >> returnValue [
	^value
]

{ #category : #evaluating }
SeamlessReturnValueResult >> value [
	^value
]

{ #category : #accessing }
SeamlessReturnValueResult >> value: anObject [
	value := anObject
]
