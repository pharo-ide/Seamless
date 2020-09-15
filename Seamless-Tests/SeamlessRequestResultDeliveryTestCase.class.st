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
	senderPeer stub isConnected willReturn: true.
	
	delivery := self createDelivery
]

{ #category : #tests }
SeamlessRequestResultDeliveryTestCase >> testDeliveringResult [

	| request result resultValue |
	request := SeamlessMessageSendRequest new.
	result := Mock new.
	delivery shipResult: result.
	
	resultValue := delivery deliverResultFor: request.
	
	resultValue should beReturnedFrom: [ result returnValue ]
]

{ #category : #tests }
SeamlessRequestResultDeliveryTestCase >> testDeliveringResultShouldFailAtTheMiddleWhenSenderPeerBecameDisconnected [ 
	| deliveryIsStarted deliveryIsDone |
	[deliveryIsStarted := true. 
	[delivery deliverResultFor: #request] should raise: SeamlessResultDeliveryUnavailable.
	deliveryIsDone := true] fork.
	[deliveryIsStarted] should takeAWhile to be: true.
	deliveryIsDone should not be: true.

	20 milliSeconds wait.
	senderPeer stub isConnected willReturn: false.
	[deliveryIsDone] should takeAWhile to be: true.
]

{ #category : #tests }
SeamlessRequestResultDeliveryTestCase >> testDeliveringResultShouldFailWhenSenderPeerIsNotConnected [

	senderPeer stub isConnected willReturn: false. 
	
	[delivery deliverResultFor: #request] should raise: SeamlessResultDeliveryUnavailable
]

{ #category : #tests }
SeamlessRequestResultDeliveryTestCase >> testDeliveringResultShouldKeepTransferredBytesInGivenRequest [

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

{ #category : #tests }
SeamlessRequestResultDeliveryTestCase >> testShipingResultShouldBeSynchronousWithDelivering [

	| request result receiverProcess receiverStarted |
	request := SeamlessMessageSendRequest new.
	result := Mock new.
	
	receiverProcess := [receiverStarted := true. delivery deliverResultFor: request] fork.
	[receiverStarted] should takeAWhile to be: true.
	
	delivery shipResult: result.
	
	result should takeAWhile to receive returnValue
		inProcessWhich should be: receiverProcess
]
