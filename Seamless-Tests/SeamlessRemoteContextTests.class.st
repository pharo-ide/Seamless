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
SeamlessRemoteContextTests >> testIgnoresClosedPeerErrorDuringResultReturn [
	
	| senderPeer network |
	network := Mock new.
	senderPeer := Mock new.
	senderPeer stub network willReturn: network.
	(senderPeer stub sendObject: Any) willRaise: BasysRemotePeerClosed new.
	
	context return: #result to: senderPeer.
	
	network should receive removeDistributedObject: context
]

{ #category : #tests }
SeamlessRemoteContextTests >> testIgnoresNoConnectionErrorDuringResultReturn [
	
	| senderPeer network |
	network := Mock new.
	senderPeer := Mock new.
	senderPeer stub network willReturn: network.
	(senderPeer stub sendObject: Any) willRaise: BasysNoConnection new.
	
	context return: #result to: senderPeer.
	
	network should receive removeDistributedObject: context
]

{ #category : #tests }
SeamlessRemoteContextTests >> testRemovesItselfFromDistributedObjectsWhenCompletesResultReturn [
	
	| senderPeer network |
	network := Mock new.
	senderPeer := Mock new.
	senderPeer stub network willReturn: network.
	
	context return: #result to: senderPeer.
	
	[senderPeer sendObject: Any.
	network removeDistributedObject: context] should beDoneInOrder 
]

{ #category : #tests }
SeamlessRemoteContextTests >> testSendsRequestToReturnResult [
	
	| senderPeer |
	senderPeer := Mock new.
	senderPeer stub sendObject: Arg request.
	
	context return: #result to: senderPeer.
	
	Arg request should beInstanceOf: SeamlessDeliverResultRequest.
	Arg request where context should be: context.
	Arg request where result should be: #result
]
