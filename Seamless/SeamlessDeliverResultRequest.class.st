"
I deliver result of sync requests to caller peer. Look at SeamlessMessageSendRequest comment for detailes about result object.

My instance could be created as 

	SeamlessDeliverResultReequest result: aRequestResult
	 
Internal Representation and Key Implementation Points.

    Instance Variables
	result:		<SeamlessRequestResult>
"
Class {
	#name : #SeamlessDeliverResultRequest,
	#superclass : #SeamlessRequest,
	#instVars : [
		'result'
	],
	#category : 'Seamless-Requests'
}

{ #category : #'instance creation' }
SeamlessDeliverResultRequest class >> result: aSeamlessRequestResult to: aSeamlessRemoteContext [
	^self new 
		context: aSeamlessRemoteContext;
		result: aSeamlessRequestResult 
]

{ #category : #execution }
SeamlessDeliverResultRequest >> executeFor: senderPeer [
	
	context return: result
]

{ #category : #accessing }
SeamlessDeliverResultRequest >> ownBytes: aNumber [

	result transferredBytes: aNumber
]

{ #category : #accessing }
SeamlessDeliverResultRequest >> result [
	^ result
]

{ #category : #accessing }
SeamlessDeliverResultRequest >> result: anObject [
	result := anObject
]
