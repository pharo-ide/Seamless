Extension { #name : #BasysRemotePeerTestCase }

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testCreateResultDeliveryForRequests [

	| delivery |
	delivery := peer createResultDeliveryForRequests.

	delivery should beReturnedFrom: [ network createDeliveryForResultFrom: peer ]
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testCreateSyncRequestContext [

	| context |
	context := peer createSyncRequestContext.

	context should beInstanceOf: SeamlessSyncRequestContext.
	context receiverPeer should be: peer
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testDestroyShouldAskNetworkForCleanupAfterNotificationRequest [

	(peer stub sendDataPacket: Any) willReturnYourself.
	
	peer destroy.
		
	[ peer sendDataPacket: Any.
	network cleanDestroyedPeer: peer ] should beDoneInOrder
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testDestroyShouldIgnoreConnectionProblemDuringPeerNotification [

	(peer stub sendDataPacket: Any) willRaise: ConnectionTimedOut new.
	
	peer destroy.
		
	network should receive cleanDestroyedPeer: peer
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testDestroyShouldIgnoreIdentificationFailureDuringPeersNotifications [

	(peer stub sendDataPacket: Any) willRaise: BasysIdentificationFailed new.
	
	peer destroy.
		
	network should receive cleanDestroyedPeer: peer
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testDestroyShouldIgnoreTimeoutProblemDuringPeersNotifications [

	(peer stub sendDataPacket: Any) willRaise: OPTimedOutError new.
	
	peer destroy.
		
	network should receive cleanDestroyedPeer: peer
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testDestroyShouldSendNotificationRequestToRemoteSide [
	
	(peer stub sendDataPacket: Arg request) willReturnYourself.
	
	peer destroy.
		
	Arg request should beInstanceOf: SeamlessPeerDestroyedRequest
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testDestroyShouldSignalUnexpectedProblemsDuringRemoteSideNotifications [

	| unexpectedProblem |
	unexpectedProblem := Error new.
	(peer stub sendDataPacket: Any) willRaise: unexpectedProblem.
		
	[peer destroy] should raise: unexpectedProblem.
		
	network should not receive cleanDestroyedPeer: Any
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testDestroyedOnRemoteSide [

	peer destroyedOnRemoteSide.
	
	network should receive cleanDestroyedPeer: peer
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testEvaluateBlockRemotelly [

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
