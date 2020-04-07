Extension { #name : #BasysRemotePeerTestCase }

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testCreationSyncRequestContext [

	| context |
	context := peer createSyncRequestContext.

	context should beInstanceOf: SeamlessSyncRequestContext.
	context receiverPeer should be: peer.
	context senderProcess should be: Processor activeProcess
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testDestroyedOnRemoteSide [

	peer destroyedOnRemoteSide.
	
	network should receive cleanDestroyedPeer: peer
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testDestroyingShouldAskNetworkForCleanupAfterNotificationRequest [

	(peer stub sendDataPacket: Any) willReturnYourself.
	
	peer destroy.
		
	[ peer sendDataPacket: Any.
	network cleanDestroyedPeer: peer ] should beDoneInOrder
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testDestroyingShouldIgnoreConnectionProblemDuringPeerNotification [

	(peer stub sendDataPacket: Any) willRaise: ConnectionTimedOut new.
	
	peer destroy.
		
	network should receive cleanDestroyedPeer: peer
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testDestroyingShouldIgnoreIdentificationFailureDuringPeersNotifications [

	(peer stub sendDataPacket: Any) willRaise: BasysIdentificationFailed new.
	
	peer destroy.
		
	network should receive cleanDestroyedPeer: peer
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testDestroyingShouldIgnoreTimeoutProblemDuringPeersNotifications [

	(peer stub sendDataPacket: Any) willRaise: OPTimedOutError new.
	
	peer destroy.
		
	network should receive cleanDestroyedPeer: peer
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testDestroyingShouldSendNotificationRequestToRemoteSide [
	
	(peer stub sendDataPacket: Any) willReturnYourself.
	
	peer destroy.
		
	peer should receive sendDataPacket: (Kind of: SeamlessPeerDestroyedRequest).
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testDestroyingShouldSignalUnexpectedProblemsDuringRemoteSideNotifications [

	| unexpectedProblem |
	unexpectedProblem := Error new.
	(peer stub sendDataPacket: Any) willRaise: unexpectedProblem.
		
	[peer destroy] should raise: unexpectedProblem.
		
	network should not receive cleanDestroyedPeer: Any
]

{ #category : #'*Seamless-Tests' }
BasysRemotePeerTestCase >> testEvaluationBlockRemotelly [

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
