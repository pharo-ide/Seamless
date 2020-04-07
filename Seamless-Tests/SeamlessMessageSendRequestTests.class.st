Class {
	#name : #SeamlessMessageSendRequestTests,
	#superclass : #SeamlessRequestTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessMessageSendRequestTests >> requestClass [
	^SeamlessMessageSendRequest 
]

{ #category : #tests }
SeamlessMessageSendRequestTests >> testExecutionWithBasysCommunicationFailure [

	| error |
	[:messageSend |
		error := Exception new messageText: 'remote error'.
		request valuable: messageSend.
		
		messageSend stub value will: [BasysCommunicationFailed by: error. error signal].
		context stub return: Arg result to: #senderPeer.		
		
		request executeFor: #senderPeer.
		
		Arg result should beInstanceOf: SeamlessThrowExceptionResult.
		Arg result where exception should beInstanceOf: SeamlessRemoteException.
		Arg result where exception messageText should equal: error printString
	] runWithMocks 
]

{ #category : #tests }
SeamlessMessageSendRequestTests >> testExecutionWithHaltRaised [

	[:messageSend |
		request valuable: messageSend.
		
		messageSend stub value willRaise: Halt.
		
		[request executeFor: #senderPeer]	should raise: Halt  
			
	] runWithMocks
]

{ #category : #tests }
SeamlessMessageSendRequestTests >> testExecutionWithNonLocalReturn [

	| nonLocalReturn |
	[:messageSend |
		request valuable: messageSend.
		nonLocalReturn := BlockCannotReturn new result: #returnedValue; home: #context.
		messageSend stub value willRaise: nonLocalReturn.
		context stub return: Arg result to: #senderPeer.
		
		request executeFor: #senderPeer.
		
		Arg result should beInstanceOf: SeamlessNonLocalReturnResult.
		Arg result where value should be: #returnedValue.
		Arg result where homeContext should be: #context
	] runWithMocks 
]

{ #category : #tests }
SeamlessMessageSendRequestTests >> testExecutionWithNormalResult [

	[:messageSend |
		request valuable: messageSend.
		messageSend stub value willReturn: #messageResult.
		context stub return: Arg result to: #senderPeer.
		
		request executeFor: #senderPeer.

		Arg result should beInstanceOf: SeamlessReturnValueResult.
		Arg result where returnValue should be: #messageResult
	] runWithMocks 
]

{ #category : #tests }
SeamlessMessageSendRequestTests >> testExecutionWithNotificationRaised [

	[:messageSend |
		request valuable: messageSend.
		messageSend stub value willRaise: Notification.

		[request executeFor: #senderPeer] should raise: Notification
		
	] runWithMocks 
]

{ #category : #tests }
SeamlessMessageSendRequestTests >> testExecutionWithRaisedError [

	| error |
	[:messageSend |
		request valuable: messageSend.
		error := Exception new messageText: 'remote error'.
		messageSend stub value willRaise: error.
		context stub return: Arg result to: #senderPeer.		
		
		request executeFor: #senderPeer.
		
		Arg result should beInstanceOf: SeamlessThrowExceptionResult.
		Arg result where exception should beInstanceOf: SeamlessRemoteException.
		Arg result where exception messageText should equal: error printString
	] runWithMocks 
]

{ #category : #tests }
SeamlessMessageSendRequestTests >> testExecutionWithRaisedSeamlessRemoteException [

	| error |
	[:messageSend |
		request valuable: messageSend.
		error := SeamlessRemoteException new messageText: 'remote error'.
		messageSend stub value willRaise: error.
		context stub return: Arg result to: #senderPeer.		
		
		request executeFor: #senderPeer.
		
		Arg result should beInstanceOf: SeamlessThrowExceptionResult.
		Arg result where exception should beInstanceOf: SeamlessRemoteException.
		"Arg result exception messageText should equal: error messageText."
	] runWithMocks 
]

{ #category : #tests }
SeamlessMessageSendRequestTests >> testShouldSaveTransferredExceptionBytes [

	[:messageSend |
		request valuable: messageSend.
		messageSend stub value willRaise: Error new.
		(context stub return: Any to: Any) will: [ :error :peer |  
			error transferredBytes: #exceptionBytes].
		
		request executeFor: #senderPeer.
		
		request resultBytes should be: #exceptionBytes
	] runWithMocks 
]

{ #category : #tests }
SeamlessMessageSendRequestTests >> testShouldSaveTransferredResultBytes [

	(context stub return: Any to: Any)
			will: [:result :peer | result transferredBytes: #resultBytes].
		
	request executeFor: Any.

	request resultBytes should be: #resultBytes
]
