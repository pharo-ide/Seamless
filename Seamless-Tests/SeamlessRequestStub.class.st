"
I am special request to test object transporter protocols.
I am created with object as my content:

	SeamlessRequestStub with: 10->20
"
Class {
	#name : #SeamlessRequestStub,
	#superclass : #SeamlessRequest,
	#instVars : [
		'content'
	],
	#category : 'Seamless-Tests'
}

{ #category : #testing }
SeamlessRequestStub class >> definesWellKnownSeamlessClass [
	^false
]

{ #category : #'instance creation' }
SeamlessRequestStub class >> with: anObject [
	^self new 
		content: anObject
]

{ #category : #accessing }
SeamlessRequestStub >> content [
	^ content
]

{ #category : #accessing }
SeamlessRequestStub >> content: anObject [
	content := anObject
]
