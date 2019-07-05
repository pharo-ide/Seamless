Class {
	#name : #SeamlessPeerDestroyedRequestTests,
	#superclass : #SeamlessRequestTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessPeerDestroyedRequestTests >> requestClass [
	^SeamlessPeerDestroyedRequest
]

{ #category : #tests }
SeamlessPeerDestroyedRequestTests >> testExecution [

	[:senderPeer |
		
		request executeFor: senderPeer.
		
		senderPeer should receive destroyedOnRemoteSide
	
	] runWithMocks 
]
