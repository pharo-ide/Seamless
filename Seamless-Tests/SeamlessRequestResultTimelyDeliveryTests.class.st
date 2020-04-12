Class {
	#name : #SeamlessRequestResultTimelyDeliveryTests,
	#superclass : #SeamlessRequestResultDeliveryTestCase,
	#category : #'Seamless-Tests'
}

{ #category : #running }
SeamlessRequestResultTimelyDeliveryTests >> createDelivery [
	^SeamlessRequestResultTimelyDelivery maxTime: 10 seconds
]

{ #category : #tests }
SeamlessRequestResultTimelyDeliveryTests >> testDeliveringResultForGivenRequestShouldFailWhenMaxTimeIsExceeded [

	| request |
	request := SeamlessMessageSendRequest new.
	delivery maxTime: 10 milliSeconds.
	
	[delivery deliverResultFor: request] should raise: SeamlessRequestTimeout 
]
