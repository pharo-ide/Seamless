Class {
	#name : 'SeamlessRequestResultDeliveryTests',
	#superclass : 'SeamlessRequestResultDeliveryTestCase',
	#category : 'Seamless-Tests',
	#package : 'Seamless-Tests'
}

{ #category : 'running' }
SeamlessRequestResultDeliveryTests >> createDelivery [
	^SeamlessRequestResultDelivery from: senderPeer
]
