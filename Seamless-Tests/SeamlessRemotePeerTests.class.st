Class {
	#name : #SeamlessRemotePeerTests,
	#superclass : #BasysRemotePeerTests,
	#category : #'Seamless-Tests'
}

{ #category : #testing }
SeamlessRemotePeerTests class >> shouldInheritSelectors [ 
	^true
]

{ #category : #running }
SeamlessRemotePeerTests >> peerClass [
	^SeamlessRemotePeer
]

{ #category : #tests }
SeamlessRemotePeerTests >> testClosingByRemoteSide [

	peer closeByRemoteSide.
		
	peer should be isClosed
]

{ #category : #tests }
SeamlessRemotePeerTests >> testClosingByRemoteSideShouldNotSendCloseRequest [

	peer stub.
	
	peer closeByRemoteSide.
		
	peer should not receive sendObject: Any
]

{ #category : #tests }
SeamlessRemotePeerTests >> testClosingShouldIgnoreConnectionTimeoutDuringClosePeerRequest [

	peer stub isConnected willReturn: true.
	(peer stub sendObject: Any) willRaise: ConnectionTimedOut new.
	
	peer close.
		
	peer should be isClosed
]

{ #category : #tests }
SeamlessRemotePeerTests >> testClosingShouldIgnoreIdentificationFailureDuringClosePeerRequest [

	peer stub isConnected willReturn: true.
	(peer stub sendObject: Any) willRaise: BasysIdentificationFailed new.
	
	peer close.
		
	peer should be isClosed
]

{ #category : #tests }
SeamlessRemotePeerTests >> testClosingShouldIgnoreNoConnectionErrorDuringClosePeerRequest [

	peer stub isConnected willReturn: true.
	(peer stub sendObject: Any) willRaise: BasysNoConnection new.
	
	peer close.
		
	peer should be isClosed
]

{ #category : #tests }
SeamlessRemotePeerTests >> testClosingShouldNotSendCloseRequestWhenItIsNotConnected [
	peer stub isConnected willReturn: false.
		
	peer close.
	
	peer should not receive sendObject: Any.
	peer should be isClosed
]

{ #category : #tests }
SeamlessRemotePeerTests >> testClosingShouldSendCloseRequestToRemoteSideWhenItIsConnected [
	peer stub isConnected willReturn: true.
	(peer stub sendObject: Arg request) 
		when: [ peer isClosed ] is: false;
		willReturnYourself.		
	
	peer close.
		
	Arg request should beInstanceOf: SeamlessClosePeerRequest.
	peer should be isClosed
]

{ #category : #tests }
SeamlessRemotePeerTests >> testClosingShouldSignalUnexpectedProblemsDuringClosePeerRequest [

	| unexpectedProblem |
	peer stub isConnected willReturn: true.
	unexpectedProblem := Error new.
	(peer stub sendObject: Any) willRaise: unexpectedProblem.
		
	[peer close] should raise: unexpectedProblem.
		
	peer should not be isClosed
]

{ #category : #tests }
SeamlessRemotePeerTests >> testCreateResultDeliveryForRequests [

	| delivery |
	delivery := peer createResultDeliveryForRequests.

	delivery should beReturnedFrom: [ network createDeliveryForResultFrom: peer ]
]

{ #category : #tests }
SeamlessRemotePeerTests >> testCreateSyncRequestContext [

	| context |
	context := peer createSyncRequestContext.

	context should beInstanceOf: SeamlessSyncRequestContext.
	context receiverPeer should be: peer
]

{ #category : #tests }
SeamlessRemotePeerTests >> testRemoteBlockAsyncEvaluation [

	(peer stub sendObject: Arg request) will: [].
			
	peer evaluateAsync: #block.

	Arg request should beInstanceOf: SeamlessBlockEvaluationRequest.
	Arg request where valuable should be: #block.
]

{ #category : #tests }
SeamlessRemotePeerTests >> testRemoteBlockEvaluationShouldReturnResultOfRequestSend [

	| context result |
	context := Mock new.
	peer stub createSyncRequestContext willReturn: context.
		
	result := peer evaluate: #block.

	result should beReturnedFrom: [ context sendRequest: Any ]
]

{ #category : #tests }
SeamlessRemotePeerTests >> testRemoteBlockEvaluationShouldSendEvaluationRequestToSyncContext [

	| context |
	context := Mock new.
	peer stub createSyncRequestContext willReturn: context.
	context stub sendRequest: Arg request.
		
	peer evaluate: #block.

	Arg request should beInstanceOf: SeamlessBlockEvaluationRequest.
	Arg request where valuable should be: #block
]
