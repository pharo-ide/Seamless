"
I am root of request contexts which are used to send requests over network to receiver peer.

My subclasses should implement method #sendRequest: which will send given request to receiver remote peer.
Also they should implement return method without interaction with sender peer because sender in that case will be always remote peer which returned result by proxy request on their side. 

Public API and Key Messages

- sendRequest: aSeamlessRequest
- return: anObject
	should return anObject in context of local sender process.

    Instance Variables
	receiverPeer:		<BasysRemotePeer>
"
Class {
	#name : #SeamlessRequestSendingContext,
	#superclass : #SeamlessRequestContext,
	#instVars : [
		'receiverPeer'
	],
	#category : 'Seamless-Requests'
}

{ #category : #'instance creation' }
SeamlessRequestSendingContext class >> receiverPeer: aRemotePeer [

	^self new 
		receiverPeer: aRemotePeer
]

{ #category : #accessing }
SeamlessRequestSendingContext >> network [
	^receiverPeer network
]

{ #category : #accessing }
SeamlessRequestSendingContext >> receiverPeer [
	^ receiverPeer
]

{ #category : #accessing }
SeamlessRequestSendingContext >> receiverPeer: anObject [
	receiverPeer := anObject
]

{ #category : #operations }
SeamlessRequestSendingContext >> return: aSeamlessRequestResult [
	self subclassResponsibility 
]

{ #category : #operations }
SeamlessRequestSendingContext >> return: aSeamlessRequestResult to: senderPeer [

	self return: aSeamlessRequestResult
]

{ #category : #operations }
SeamlessRequestSendingContext >> sendRequest: aSeamlessRequest [
	self subclassResponsibility 
]
