Class {
	#name : #SeamlessEvaluationRequestTests,
	#superclass : #SeamlessRequestTestCase,
	#category : #'Seamless-Tests'
}

{ #category : #running }
SeamlessEvaluationRequestTests >> requestClass [
	^SeamlessMessageSendRequest 
]

{ #category : #tests }
SeamlessEvaluationRequestTests >> testExecutionWithHaltRaised [

	request valuable: [ Halt now ].
		
	[request executeFor: #senderPeer]	should raise: Halt  
]

{ #category : #tests }
SeamlessEvaluationRequestTests >> testExecutionWithNonLocalReturn [

	| nonLocalReturn |
	nonLocalReturn := BlockCannotReturn new result: #returnedValue; home: #context.
	request valuable: [ nonLocalReturn signal ].
	context stub return: Arg result to: #senderPeer.
		
	request executeFor: #senderPeer.
		
	Arg result should beInstanceOf: SeamlessNonLocalReturnResult.
	Arg result where value should be: #returnedValue.
	Arg result where homeContext should be: #context
]

{ #category : #tests }
SeamlessEvaluationRequestTests >> testExecutionWithNormalResult [

	request valuable: [ #result ].
	context stub return: Arg result to: #senderPeer.
		
	request executeFor: #senderPeer.

	Arg result should beInstanceOf: SeamlessReturnValueResult.
	Arg result where returnValue should be: #result
]

{ #category : #tests }
SeamlessEvaluationRequestTests >> testExecutionWithNotificationRaised [

	request valuable: [ Notification signal ].

	[request executeFor: #senderPeer] should raise: Notification
]

{ #category : #tests }
SeamlessEvaluationRequestTests >> testExecutionWithRaisedError [

	| error |
	error := Exception new messageText: 'remote error'.
	request valuable: [ error signal ].
	context stub return: Arg result to: #senderPeer.		
		
	request executeFor: #senderPeer.
		
	Arg result should beInstanceOf: SeamlessThrowExceptionResult.
	Arg result where exception should beInstanceOf: SeamlessRemoteException.
	Arg result where exception messageText should equal: error printString
]

{ #category : #tests }
SeamlessEvaluationRequestTests >> testExecutionWithRaisedSeamlessRemoteException [

	| error |
	error := SeamlessRemoteException new messageText: 'remote error'.
	request valuable: [ error signal ].
	context stub return: Arg result to: #senderPeer.		
		
	request executeFor: #senderPeer.
		
	Arg result should beInstanceOf: SeamlessThrowExceptionResult.
	Arg result where exception should beInstanceOf: SeamlessRemoteException.
	"Arg result where exception messageText should equal: error messageText."
]

{ #category : #tests }
SeamlessEvaluationRequestTests >> testShouldSaveTransferredExceptionBytes [

	request valuable: [ Error signal ].
	(context stub return: Any to: Any) will: [ :errorResult :peer |  
		errorResult transferredBytes: #exceptionBytes].
		
	request executeFor: #senderPeer.
		
	request resultBytes should be: #exceptionBytes
]

{ #category : #tests }
SeamlessEvaluationRequestTests >> testShouldSaveTransferredResultBytes [

	(context stub return: Any to: Any)
			will: [:result :peer | result transferredBytes: #resultBytes].
		
	request executeFor: Any.

	request resultBytes should be: #resultBytes
]
