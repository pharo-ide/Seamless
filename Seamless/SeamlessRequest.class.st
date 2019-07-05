"
I am root of Seamless requests hierarchy which are sent between network peers.

My subclasses should implement method #executeFor: senderPeer.
My context is logical presentation of sender context which allow return results to it. Look at SeamlessRequestContext comments

I also include statistics information about how many bytes was used to transfer me and my result (ownBytes and resultBytes)

Public API and Key Messages

- executeFor: senderContext
 
    Instance Variables
	context:		<SeamlessRequestContext>
	ownBytes:	<Integer>
	resultBytes:	<Integer>
"
Class {
	#name : #SeamlessRequest,
	#superclass : #Object,
	#instVars : [
		'context',
		'resultBytes',
		'ownBytes'
	],
	#category : 'Seamless-Requests'
}

{ #category : #testing }
SeamlessRequest class >> definesWellKnownSeamlessClass [
	^true
]

{ #category : #testing }
SeamlessRequest class >> definesWellKnownSeamlessClassHierarchy [ 
	^true
]

{ #category : #accessing }
SeamlessRequest >> context [
	^ context
]

{ #category : #accessing }
SeamlessRequest >> context: anObject [
	context := anObject
]

{ #category : #execution }
SeamlessRequest >> executeFor: senderPeer [
	self subclassResponsibility 
]

{ #category : #initialization }
SeamlessRequest >> initialize [
	super initialize.
	
	context := SeamlessRequestContext default.
	ownBytes := resultBytes := 0
]

{ #category : #testing }
SeamlessRequest >> isIncoming [
	^self isOutgoing not
]

{ #category : #testing }
SeamlessRequest >> isOnlyDefaultTransferStrategyAllowed [
	^true
]

{ #category : #testing }
SeamlessRequest >> isOutgoing [
	^context isKindOf: SeamlessRequestSendingContext
]

{ #category : #accessing }
SeamlessRequest >> ownBytes [
	^ ownBytes
]

{ #category : #accessing }
SeamlessRequest >> ownBytes: anObject [
	ownBytes := anObject
]

{ #category : #printing }
SeamlessRequest >> printMessageForLog [
	^self printString
]

{ #category : #accessing }
SeamlessRequest >> resultBytes [
	^ resultBytes
]

{ #category : #accessing }
SeamlessRequest >> resultBytes: anObject [
	resultBytes := anObject
]

{ #category : #accessing }
SeamlessRequest >> seamlessDefaultTransferStrategy [ 
	^SeamlessTransferStrategy defaultByValue 
]

{ #category : #accessing }
SeamlessRequest >> transferredBytes [
	^ ownBytes + resultBytes
]
