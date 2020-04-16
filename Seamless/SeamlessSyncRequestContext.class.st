"
I am request context which implements synchronous request sending when senders are waiting result from receiver peer.
To implement this behaviour send a request to receiver peer and wait a delivery of result from it. 
I am transfered by reference to receiver peer as part of sent request. On receiver side request executed and result is returned to me by SeamlessDeliverResultRequest using same context. At the end I receive #return: message which shifts the argument to the result delivery. Delivery signals the original sender process which continue execution with received value.

During request execution the receiver peer will keep reference to me. It can be used to retrieved information on receiver side about my sender process. 
 
Internal Representation and Key Implementation Points.

    Instance Variables
	senderProcess:		<Process>
	resultDelivery		<SeamlessRequestResultDelivery>
"
Class {
	#name : #SeamlessSyncRequestContext,
	#superclass : #SeamlessRequestSendingContext,
	#instVars : [
		'senderProcess',
		'resultDelivery'
	],
	#category : #'Seamless-Requests'
}

{ #category : #accessing }
SeamlessSyncRequestContext >> createSeamlessReference [
	^SeamlessRequestContextReference new
]

{ #category : #private }
SeamlessSyncRequestContext >> performRequestSend: aSeamlessRequest [
	receiverPeer sendDataPacket: aSeamlessRequest 
]

{ #category : #accessing }
SeamlessSyncRequestContext >> receiverPeer: anObject [
	super receiverPeer: anObject.
	resultDelivery := receiverPeer createResultDeliveryForRequests 
]

{ #category : #accessing }
SeamlessSyncRequestContext >> resultDelivery [
	^ resultDelivery
]

{ #category : #accessing }
SeamlessSyncRequestContext >> resultDelivery: anObject [
	resultDelivery := anObject
]

{ #category : #operations }
SeamlessSyncRequestContext >> return: aSeamlessRequestResult [

	resultDelivery shipResult: aSeamlessRequestResult.
	
	self network removeDistributedObject: self
]

{ #category : #operations }
SeamlessSyncRequestContext >> sendMessage: aMessageSend [

	^self sendRequest: (SeamlessMessageSendRequest with: aMessageSend)
]

{ #category : #operations }
SeamlessSyncRequestContext >> sendRequest: aSeamlessRequest [ 

	aSeamlessRequest context: self.
	senderProcess := Processor activeProcess.
	
	self performRequestSend: aSeamlessRequest.

	^resultDelivery deliverResultFor: aSeamlessRequest
]

{ #category : #accessing }
SeamlessSyncRequestContext >> senderProcess [
	^ senderProcess
]

{ #category : #accessing }
SeamlessSyncRequestContext >> senderProcess: anObject [
	senderProcess := anObject
]
