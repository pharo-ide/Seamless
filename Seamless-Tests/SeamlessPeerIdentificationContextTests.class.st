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
SeamlessPeerIdentificationContextTests >> contextShouldSend: aSeamlessRequest [

	^connection should receive sendDataPacket: aSeamlessRequest 
]

{ #category : #running }
SeamlessPeerIdentificationContextTests >> setUp [
	super setUp.
	
	connection := Mock new.
	
	context connection: connection
]

{ #category : #specs }
SeamlessPeerIdentificationContextTests >> stubRequestDataSend: aSeamlessRequest [

	^connection stub sendDataPacket: aSeamlessRequest 
]
