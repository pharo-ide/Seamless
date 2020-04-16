Class {
	#name : #SeamlessRequestResultDeliveryTestCase,
	#superclass : #TestCase,
	#instVars : [
		'delivery',
		'senderPeer'
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
	
	senderPeer := Mock new.
	delivery := self createDelivery
]

{ #category : #tests }
SeamlessRequestResultDeliveryTestCase >> testDeliveringResultForGivenRequest [

	| request result resultValue |
	request := SeamlessMessageSendRequest new.
	result := Mock new.
	delivery shipResult: result.
	
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
	
	delivery shipResult: result.
	
	result should takeAWhile to receive returnValue
		inProcessWhich should be: receiverProcess
]

{ #category : #tests }
SeamlessRequestResultDeliveryTestCase >> testDeliveringResultForGivenRequestShouldKeepTransferredBytes [

	| request result |
	request := SeamlessMessageSendRequest new.
	result := Mock new.
	delivery shipResult: result.
	
	delivery deliverResultFor: request.
	
	request resultBytes should beReturnedFrom: [ result transferredBytes ]
]

{ #category : #tests }
SeamlessRequestResultDeliveryTestCase >> testShipingGivenResult [

	delivery shipResult: #result.
	
	delivery requestResult should be: #result
]
