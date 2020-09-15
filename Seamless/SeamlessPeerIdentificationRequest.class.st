"
I perform sender peer identification with given peerId and return current local peer id to sender.
For more details look at BasysNetwork comments

    Instance Variables
	peerId:		<Object>
"
Class {
	#name : #SeamlessPeerIdentificationRequest,
	#superclass : #SeamlessRequest,
	#instVars : [
		'peerId'
	],
	#category : 'Seamless-Requests'
}

{ #category : #'instance creation' }
SeamlessPeerIdentificationRequest class >> peerId: peerId [
	^self new 
		peerId: peerId
]

{ #category : #execution }
SeamlessPeerIdentificationRequest >> executeFor: senderPeer [
	
	senderPeer ensureIdentity: peerId.
	
	context returnValue: senderPeer localPeerId to: senderPeer
]

{ #category : #accessing }
SeamlessPeerIdentificationRequest >> peerId [
	^ peerId
]

{ #category : #accessing }
SeamlessPeerIdentificationRequest >> peerId: anObject [
	peerId := anObject
]
