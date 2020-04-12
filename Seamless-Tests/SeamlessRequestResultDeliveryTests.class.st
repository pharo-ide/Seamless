Class {
	#name : #SeamlessRequestResultDeliveryTests,
	#superclass : #TestCase,
	#instVars : [
		'delivery'
	],
	#category : #'Seamless-Tests'
}

{ #category : #running }
SeamlessRequestResultDeliveryTests >> setUp [
	super setUp.
	
	delivery := SeamlessRequestResultDelivery new
]

{ #category : #tests }
SeamlessRequestResultDeliveryTests >> testDeliveringGivenResult [

	delivery deliverResult: #result.
	
	delivery requestResult should be: #result
]

{ #category : #tests }
SeamlessRequestResultDeliveryTests >> testDeliveringResultForGivenRequest [

	| request result resultValue |
	request := SeamlessMessageSendRequest new.
	result := Mock new.
	delivery deliverResult: result.
	
	resultValue := delivery deliverResultFor: request.
	
	resultValue should beReturnedFrom: [ result returnValue ]
]

{ #category : #tests }
SeamlessRequestResultDeliveryTests >> testDeliveringResultForGivenRequestShouldBeSynchronous [

	| request result receiverProcess receiverStarted |
	request := SeamlessMessageSendRequest new.
	result := Mock new.
	
	receiverProcess := [receiverStarted := true. delivery deliverResultFor: request] fork.
	[receiverStarted] should takeAWhile to be: true.
	
	delivery deliverResult: result.
	
	result should takeAWhile to receive returnValue
		inProcessWhich should be: receiverProcess
]

{ #category : #tests }
SeamlessRequestResultDeliveryTests >> testDeliveringResultForGivenRequestShouldKeepTransferredBytes [

	| request result |
	request := SeamlessMessageSendRequest new.
	result := Mock new.
	delivery deliverResult: result.
	
	delivery deliverResultFor: request.
	
	request resultBytes should beReturnedFrom: [ result transferredBytes ]
]
