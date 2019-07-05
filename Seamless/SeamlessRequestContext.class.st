"
I am root of SeamlessRequest contexts.
My subclasses represents specific kind of request sender contexts. They should implement method 
	return: aSeamlessRequestResult to: senderPeer
which returns request result to sender. 
For details look at subclasses comments.

Returned results should be subclasses of SeamlessRequestResult. See it comments

Public API and Key Messages

- return: aSeamlessRequestResult to: senderPeer
- returnValue: aObject to: senderPeer
	it returns anObject to sender as SeamlessReturnValueResult

"
Class {
	#name : #SeamlessRequestContext,
	#superclass : #Object,
	#classVars : [
		'Default'
	],
	#category : 'Seamless-Requests'
}

{ #category : #accessing }
SeamlessRequestContext class >> default [
	^Default ifNil: [ Default := SeamlessDefaultRequestContext new ]
]

{ #category : #testing }
SeamlessRequestContext class >> definesWellKnownSeamlessClass [
	^true
]

{ #category : #testing }
SeamlessRequestContext class >> definesWellKnownSeamlessClassHierarchy [ 
	^true
]

{ #category : #testing }
SeamlessRequestContext >> isOnlyDefaultTransferStrategyAllowed [
	^true
]

{ #category : #operations }
SeamlessRequestContext >> return: aSeamlessRequestResult to: senderPeer [
	self subclassResponsibility 
]

{ #category : #operations }
SeamlessRequestContext >> returnValue: anObject to: senderPeer [

	self return: (SeamlessReturnValueResult with: anObject) to: senderPeer
]
