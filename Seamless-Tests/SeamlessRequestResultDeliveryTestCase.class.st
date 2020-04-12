Class {
	#name : #SeamlessRequestResultDeliveryTestCase,
	#superclass : #TestCase,
	#instVars : [
		'delivery'
	],
	#category : #'Seamless-Tests'
}

{ #category : #testing }
SeamlessRequestResultDeliveryTestCase class >> isAbstract [ 
	^self = SeamlessRequestResultDeliveryTestCase
]

{ #category : #running }
SeamlessRequestResultDeliveryTestCase >> createDelivery [
	self subclassResponsibility 
]

{ #category : #running }
SeamlessRequestResultDeliveryTestCase >> setUp [
	super setUp.
	
	delivery := self createDelivery
]

{ #category : #tests }
SeamlessRequestResultDeliveryTestCase >> testDeliveringGivenResult [

	delivery deliverResult: #result.
	
	delivery requestResult should be: #result
]

{ #category : #tests }
SeamlessRequestResultDeliveryTestCase >> testDeliveringResultForGivenRequest [

	| request result resultValue |
	request := SeamlessMessageSendRequest new.
	result := Mock new.
	delivery deliverResult: result.
	
	resultValue := delivery deliverResultFor: request.
	
	resultValue should beReturnedFrom: [ result returnValue ]
]

{ #category : #tests }
SeamlessRequestResultDeliveryTestCase >> testDeliveringResultForGivenRequestShouldBeSynchronous [

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
SeamlessRequestResultDeliveryTestCase >> testDeliveringResultForGivenRequestShouldKeepTransferredBytes [

	| request result |
	request := SeamlessMessageSendRequest new.
	result := Mock new.
	delivery deliverResult: result.
	
	delivery deliverResultFor: request.
	
	request resultBytes should beReturnedFrom: [ result transferredBytes ]
]
