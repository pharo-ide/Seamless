Extension { #name : #BasysRemotePeerTests }

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTests >> testCreateResultDeliveryForRequests [

	| delivery |
	delivery := peer createResultDeliveryForRequests.

	delivery should beReturnedFrom: [ network createDeliveryForResultFrom: peer ]
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTests >> testCreateSyncRequestContext [

	| context |
	context := peer createSyncRequestContext.

	context should beInstanceOf: SeamlessSyncRequestContext.
	context receiverPeer should be: peer
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTests >> testDestroyShouldAskNetworkForCleanupAfterNotificationRequest [

	(peer stub sendDataPacket: Any) willReturnYourself.
	
	peer destroy.
		
	[ peer sendDataPacket: Any.
	network cleanDestroyedPeer: peer ] should beDoneInOrder
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTests >> testDestroyShouldIgnoreConnectionProblemDuringPeerNotification [

	(peer stub sendDataPacket: Any) willRaise: ConnectionTimedOut new.
	
	peer destroy.
		
	network should receive cleanDestroyedPeer: peer
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTests >> testDestroyShouldIgnoreIdentificationFailureDuringPeersNotifications [

	(peer stub sendDataPacket: Any) willRaise: BasysIdentificationFailed new.
	
	peer destroy.
		
	network should receive cleanDestroyedPeer: peer
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTests >> testDestroyShouldSendNotificationRequestToRemoteSide [
	
	(peer stub sendDataPacket: Arg request) willReturnYourself.
	
	peer destroy.
		
	Arg request should beInstanceOf: SeamlessPeerDestroyedRequest
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTests >> testDestroyShouldSignalUnexpectedProblemsDuringRemoteSideNotifications [

	| unexpectedProblem |
	unexpectedProblem := Error new.
	(peer stub sendDataPacket: Any) willRaise: unexpectedProblem.
		
	[peer destroy] should raise: unexpectedProblem.
		
	network should not receive cleanDestroyedPeer: Any
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTests >> testDestroyedOnRemoteSide [

	peer destroyedOnRemoteSide.
	
	network should receive cleanDestroyedPeer: peer
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTests >> testEvaluateBlockRemotelly [

	| localBlock |
	[:context :block |
		localBlock := [ #localBlock ].
		peer stub createSyncRequestContext willReturn: context.
		block stub asLocalObject willReturn: localBlock.
		(context stub sendRequest: Arg request) willReturn: #result.
		
		(peer evaluate: block) should be: #result.
		Arg request should beInstanceOf: SeamlessBlockEvaluationRequest.
		Arg request where valuable should be: localBlock
	] runWithMocks 
	
]
