Class {
	#name : #SeamlessPeerIdentificationContextTests,
	#superclass : #SeamlessSyncRequestContextTests,
	#instVars : [
		'connection'
	],
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessPeerIdentificationContextTests >> contextClass [
	^SeamlessPeerIdentificationContext 
]

{ #category : #specs }
SeamlessPeerIdentificationContextTests >> requestSendSpecFor: aSeamlessRequest [
	^connection sendDataPacket: aSeamlessRequest 
]

{ #category : #running }
SeamlessPeerIdentificationContextTests >> setUp [
	super setUp.
	
	connection := Mock new.
	
	context connection: connection
]
