Class {
	#name : #SeamlessRequestSendingContextTestCase,
	#superclass : #SeamlessRequestContextTestCase,
	#instVars : [
		'receiverPeer'
	],
	#category : 'Seamless-Tests'
}

{ #category : #testing }
SeamlessRequestSendingContextTestCase class >> isAbstract [
	^self == SeamlessRequestSendingContextTestCase
]

{ #category : #running }
SeamlessRequestSendingContextTestCase >> setUp [
	super setUp.
	
	receiverPeer := Mock new.
	context receiverPeer: receiverPeer
]
