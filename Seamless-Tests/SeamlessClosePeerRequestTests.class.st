Class {
	#name : #SeamlessClosePeerRequestTests,
	#superclass : #SeamlessRequestTestCase,
	#category : #'Seamless-Tests'
}

{ #category : #running }
SeamlessClosePeerRequestTests >> requestClass [
	^SeamlessClosePeerRequest
]

{ #category : #tests }
SeamlessClosePeerRequestTests >> testExecution [

	| senderPeer |
	senderPeer := Mock new.
		
	request executeFor: senderPeer.
		
	senderPeer should receive closeByRemoteSide
]
