"
I am special context for SeamlessPeerIdentificationRequest.
My only difference from superclass is that I send requests to receiver by concrete connection which used to be identified.

Internal Representation and Key Implementation Points.

    Instance Variables
	connection:		<BasysConnection>
"
Class {
	#name : #SeamlessPeerIdentificationContext,
	#superclass : #SeamlessSyncRequestContext,
	#instVars : [
		'connection'
	],
	#category : 'Seamless-Requests'
}

{ #category : #'instance creation' }
SeamlessPeerIdentificationContext class >> for: aBasysConnection [

	^(self receiverPeer: aBasysConnection remotePeer)
		connection: aBasysConnection
]

{ #category : #accessing }
SeamlessPeerIdentificationContext >> connection [
	^ connection
]

{ #category : #accessing }
SeamlessPeerIdentificationContext >> connection: anObject [
	connection := anObject
]

{ #category : #private }
SeamlessPeerIdentificationContext >> performRequestSend: aSeamlessRequest [
	connection sendDataPacket: aSeamlessRequest 
]
