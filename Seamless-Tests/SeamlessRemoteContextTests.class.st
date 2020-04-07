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
SeamlessRemoteContextTests >> testReturningResult [
	
	[:senderPeer :network |
		[ context return: #result to: senderPeer]
			should strictly satisfy: 
		[ senderPeer sendDataPacket: Arg request.
		senderPeer network willReturn: network.
		network removeDistributedObject: context].
	
		Arg request should beInstanceOf: SeamlessDeliverResultRequest.
		Arg request where context should be: context.
		Arg request where result should be: #result
	 ] runWithMocks 
]
