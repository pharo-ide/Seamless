Class {
	#name : #SeamlessConnectionTests,
	#superclass : #BasysConnectionTests,
	#category : 'Seamless-Tests'
}

{ #category : #tests }
SeamlessConnectionTests >> testCreationIdentificationContext [

	| context |
	context := connection createIdentificationContext.

	context should beInstanceOf: SeamlessPeerIdentificationContext.
	context connection should be: connection.
	context receiverPeer should be: remotePeer
]
