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

	[:senderPeer |
		request peerId: #senderPeerId.
		
		[request executeFor: senderPeer]
			should strictly satisfy: 
		[ (senderPeer beIdentifiedAs: #senderPeerId) willReturn: #identifiedPeer.
		senderPeer localPeerId willReturn: #localPeerId.
		context returnValue: #localPeerId to: #identifiedPeer]
	
	] runWithMocks 
]
