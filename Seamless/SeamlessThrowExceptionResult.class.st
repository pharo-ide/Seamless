"
I represent exception which should be signalled on request sender side as execution result.

SeamlessMessageSendRequest uses me to return exception which was catched during message send. SeamlessRemoteException is returned in such cases with description of original error.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	exception:		<Exception>
"
Class {
	#name : #SeamlessThrowExceptionResult,
	#superclass : #SeamlessRequestResult,
	#instVars : [
		'exception'
	],
	#category : 'Seamless-Requests'
}

{ #category : #'instance creation' }
SeamlessThrowExceptionResult class >> with: anException [

	^self new 
		exception: anException
]

{ #category : #accessing }
SeamlessThrowExceptionResult >> exception [
	^ exception
]

{ #category : #accessing }
SeamlessThrowExceptionResult >> exception: anObject [
	exception := anObject
]

{ #category : #evaluating }
SeamlessThrowExceptionResult >> returnValue [

	exception signal
]
