Class {
	#name : #SeamlessSyncRequestContextTests,
	#superclass : #SeamlessRequestSendingContextTestCase,
	#instVars : [
		'resultDelivery'
	],
	#category : #'Seamless-Tests'
}

{ #category : #running }
SeamlessSyncRequestContextTests >> contextClass [
	^SeamlessSyncRequestContext 
]

{ #category : #specs }
SeamlessSyncRequestContextTests >> contextShouldSend: aSeamlessRequest [

	^receiverPeer should takeAWhile to receive sendDataPacket: aSeamlessRequest
]

{ #category : #running }
SeamlessSyncRequestContextTests >> setUp [
	super setUp.
	
	resultDelivery := Mock new.
	context resultDelivery: resultDelivery
]

{ #category : #specs }
SeamlessSyncRequestContextTests >> stubRequestDataSend: aSeamlessRequest [

	^receiverPeer stub sendDataPacket: aSeamlessRequest
]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testHasDefaultResultDeliveryFromNetwork [
	
	context receiverPeer: receiverPeer.
		
	context resultDelivery should beReturnedFrom: [ network defaultResultDeliveryForRequests ]
]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testReferenceCreation [
	
	| actual |
	actual := context createSeamlessReference.
	
	actual should beInstanceOf: SeamlessRequestContextReference
]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testReturningResult [
	
	context return: #result.

	resultDelivery should receive deliverResult: #result
]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testReturningResultShouldRemoveContextFromDistributedObjects [
			
	context return: #result.
		
	network should receive removeDistributedObject: context
]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testReturningResultToGivenPeer [
	
	context stub.
		
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
SeamlessSyncRequestContextTests >> testSendingRequestShouldAssignItToContext [
	
	| request |
	request := Mock new.
		
	context sendRequest: request.
		
	request should receive context: context
]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testSendingRequestShouldBeDoneAsynchronous [
	
	| request |
	request := Mock new.
	
	context sendRequest: request.

	(self contextShouldSend: request) inAnotherProcess
		inProcessWhich priority should equal: Processor activeProcess priority.

]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testSendingRequestShouldHoldSenderProcess [
	
	| request |
	request := Mock new.
		
	context sendRequest: request.
		
	context senderProcess should be: Processor activeProcess
]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testSendingRequestShouldReturnResultUsingDelivery [
	
	| request |
	request := Mock new.
		
	context sendRequest: request.
		
	resultDelivery should receive deliverResultFor: request
]

{ #category : #tests }
SeamlessSyncRequestContextTests >> testSendingRequestWhenSendIsFailed [
	
	| sendFailure request |
	request := Mock new.
	sendFailure := Error new.
	(self stubRequestDataSend: request) willRaise: sendFailure.
	resultDelivery stub deliverResult: Arg result.
		
	context sendRequest: request.
	
	Arg result should takeAWhile to beInstanceOf: SeamlessThrowExceptionResult.
	Arg result where exception should be: sendFailure
]
