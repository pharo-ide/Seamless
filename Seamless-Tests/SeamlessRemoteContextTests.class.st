Class {
	#name : #SeamlessRemoteContextTests,
	#superclass : #SeamlessRequestContextTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessRemoteContextTests >> contextClass [
	^SeamlessRemoteContext 
]

{ #category : #tests }
SeamlessRemoteContextTests >> testRemovesItselfFromDistributedObjectsWhenCompletesResultReturn [
	
	| senderPeer network |
	network := Mock new.
	senderPeer := Mock new.
	senderPeer stub network willReturn: network.
	
	context return: #result to: senderPeer.
	
	[senderPeer trySendObjectIfConnected: Any.
	network removeDistributedObject: context] should beDoneInOrder 
]

{ #category : #tests }
SeamlessRemoteContextTests >> testSendsRequestToReturnResult [
	
	| senderPeer |
	senderPeer := Mock new.
	senderPeer stub trySendObjectIfConnected: Arg request.
	
	context return: #result to: senderPeer.
	
	Arg request should beInstanceOf: SeamlessDeliverResultRequest.
	Arg request where context should be: context.
	Arg request where result should be: #result
]
