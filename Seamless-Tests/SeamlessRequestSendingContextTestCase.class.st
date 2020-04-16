Class {
	#name : #SeamlessRequestSendingContextTestCase,
	#superclass : #SeamlessRequestContextTestCase,
	#instVars : [
		'receiverPeer',
		'network'
	],
	#category : #'Seamless-Tests'
}

{ #category : #testing }
SeamlessRequestSendingContextTestCase class >> isAbstract [
	^self == SeamlessRequestSendingContextTestCase
]

{ #category : #running }
SeamlessRequestSendingContextTestCase >> setUp [
	super setUp.
	
	network := Mock new.
	receiverPeer := Mock new.
	receiverPeer stub network willReturn: network.
	 
	context receiverPeer: receiverPeer.
]
