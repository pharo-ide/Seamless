Class {
	#name : #SeamlessPeerIdentificationRequestTests,
	#superclass : #SeamlessRequestTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessPeerIdentificationRequestTests >> requestClass [
	^SeamlessPeerIdentificationRequest
]

{ #category : #tests }
SeamlessPeerIdentificationRequestTests >> testExecution [

	| senderPeer |
	senderPeer := Mock new.
	senderPeer stub localPeerId willReturn: #localPeerId.
	request peerId: #senderPeerId.
		
	request executeFor: senderPeer.
	
	[senderPeer ensureIdentity: #senderPeerId.
	context returnValue: #localPeerId to: senderPeer] should beDoneInOrder
]
