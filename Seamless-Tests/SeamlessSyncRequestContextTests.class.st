Class {
	#name : #SeamlessSyncRequestContextTests,
	#superclass : #SeamlessRequestSendingContextTestCase,
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessSyncRequestContextTests >> contextClass [
	^SeamlessSyncRequestContext 
]

{ #category : #specs }
SeamlessSyncRequestContextTests >> requestSendSpecFor: aSeamlessRequest [

	^receiverPeer sendDataPacket: aSeamlessRequest
]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testHasActiveProcessAsSenderProcessByDeafult [
	
	context senderProcess should be: Processor activeProcess
]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testHasResultWaiterByDefault [
	
	context resultWaiter should beInstanceOf: Semaphore
]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testReferenceCreation [
	
	| actual |
	actual := context createSeamlessReference.
	
	actual should beInstanceOf: SeamlessRequestContextReference
]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testReturningResult [
	
	[:network :waiterSemaphore |
		context resultWaiter: waiterSemaphore.
		waiterSemaphore stub signal when: [ context result ] is: #result.
		
		context return: #result.

		waiterSemaphore should receive signal
	
	 ] runWithMocks 
]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testReturningResultShouldRemoveContextFromDistributedObjects [
	
	[:network |
		receiverPeer stub network willReturn: network.
		
		context return: #result.
		
		network should receive removeDistributedObject: context.
			
	 ] runWithMocks 
]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testReturningResultToGivenPeer [
	
	context stub return: Any.
		
	context return: #result to: #senderPeer.
	
	context should receive return: #result
]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testSendingMessage [
	
	(context stub sendRequest: Arg request) willReturn: #result.
	
	(context sendMessage: #messageSend) should be: #result.
	
	Arg request should beInstanceOf: SeamlessMessageSendRequest.
	Arg request where messageSend should be: #messageSend

]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testSendingRequest [
	
	[:request :waiterSemaphore :result |
		context resultWaiter: waiterSemaphore.		
		[ (context sendRequest: request) should be: #returnedValue.
		20 milliSeconds wait ]
			should strictly satisfy: 
		[request context: context.
		 waiterSemaphore wait will: [ context result: result. Processor yield ].
		(self requestSendSpecFor: request)
				shouldBeSentInAnotherProcess;
				when: [ Processor activeProcess priority] is: Processor activeProcess priority.
		result returnValue willReturn: #returnedValue]	
	 ] runWithMocks 
]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testSendingRequestWhenSendIsFailed [
	
	| sendFailure |
	[:request |
		sendFailure := Error new.
		[(self requestSendSpecFor: request) willRaise: sendFailure] should expect.
		
		[context sendRequest: request] should raise: sendFailure
		
	] runWithMocks 
]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testShouldSaveResultBytesInRequest [
	
	[:request :waiterSemaphore :result |
		context resultWaiter: waiterSemaphore.		
		result stub transferredBytes willReturn: #resultBytes.
		waiterSemaphore stub wait will: [ context result: result. Processor yield ].
		
		context sendRequest: request.
		20 milliSeconds wait.
		
		[ waiterSemaphore wait.
		request resultBytes: #resultBytes ] should beDoneInOrder 
	 ] runWithMocks 
]
