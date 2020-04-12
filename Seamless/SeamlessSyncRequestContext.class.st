"
I am request context which implements synchronous request sending when senders are waiting result from receiver peer.
To implement this behaviour I fork actual request sending and wait signal from resultWaiter semaphore. I am transfered by reference to receiver peer as part of sent request. On receiver side request executed and result is returned to me by ""backward"" remote message. I receive #return: message which stores argument as result and signal resultWaiter semaphore. Signal resumes original sender process which continue execution with received value.

During request execution receiver peer will keep reference to me. It can be used to retrieved information on receiver side about my sender process. 
 
Internal Representation and Key Implementation Points.

    Instance Variables
	result:		<SeamlessRequestResult>
	resultWaiter:		<Semaphore>
	senderProcess:		<Process>
"
Class {
	#name : #SeamlessSyncRequestContext,
	#superclass : #SeamlessRequestSendingContext,
	#instVars : [
		'senderProcess',
		'resultWaiter',
		'result',
		'resultDelivery'
	],
	#category : #'Seamless-Requests'
}

{ #category : #accessing }
SeamlessSyncRequestContext >> createSeamlessReference [
	^SeamlessRequestContextReference new
]

{ #category : #private }
SeamlessSyncRequestContext >> forkProcessingOf: aSeamlessRequest [

	[ 
		[self performRequestSend: aSeamlessRequest] on: Error do: [ :err |
			self return:  (SeamlessThrowExceptionResult with: err) ]
	
	] forkAt: Processor activePriority named: 'Seamless request sending'
]

{ #category : #initialization }
SeamlessSyncRequestContext >> initialize [
	super initialize.
	
	resultDelivery := SeamlessRequestResultDelivery new
]

{ #category : #private }
SeamlessSyncRequestContext >> performRequestSend: aSeamlessRequest [
	receiverPeer sendDataPacket: aSeamlessRequest 
]

{ #category : #accessing }
SeamlessSyncRequestContext >> result [
	^ result
]

{ #category : #accessing }
SeamlessSyncRequestContext >> result: anObject [
	result := anObject
]

{ #category : #accessing }
SeamlessSyncRequestContext >> resultDelivery [
	^ resultDelivery
]

{ #category : #accessing }
SeamlessSyncRequestContext >> resultDelivery: anObject [
	resultDelivery := anObject
]

{ #category : #accessing }
SeamlessSyncRequestContext >> resultWaiter [
	^ resultWaiter
]

{ #category : #accessing }
SeamlessSyncRequestContext >> resultWaiter: anObject [
	resultWaiter := anObject
]

{ #category : #operations }
SeamlessSyncRequestContext >> return: aSeamlessRequestResult [

	resultDelivery deliverResult: aSeamlessRequestResult.
	
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
	
	self forkProcessingOf: aSeamlessRequest.

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
