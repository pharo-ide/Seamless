"
I am a helper object to manage the delivery of result inside SeamlessSyncRequestContext.

From the one side users which need a result should ask me for:

	delivery deliverResultFor: aRequest
	
which will wait until the result will be finally delivered. When it will happen I will return actual result value from this method. aRequest will receive transferredBytes for statistics. 

From the other side users which have a result should ship it through me using: 

	deliver shipResult: aRequestResult 
	
where I will signal all waiting users that the result is ready using my synchronizationSemaphore.

My instances are created with remote peer instance, #senderPeer, which is supposed to send the result as the response to received request:

	SeamlessRequestResultDelivery from: aRemotePeer

Internal Representation and Key Implementation Points.

    Instance Variables
	senderPeer:		<BasysRemotePeer>
	requestResult:		<SeamlessRequestResult>
	synchronizationSemaphore:		<Semaphore>
"
Class {
	#name : #SeamlessRequestResultDelivery,
	#superclass : #Object,
	#instVars : [
		'senderPeer',
		'synchronizationSemaphore',
		'requestResult'
	],
	#category : #'Seamless-Requests'
}

{ #category : #'instance creation' }
SeamlessRequestResultDelivery class >> from: aRemotePeer [
	^self new 
		senderPeer: aRemotePeer
]

{ #category : #delivery }
SeamlessRequestResultDelivery >> deliverResultFor: aRequest [

	self waitResult.
	
	aRequest resultBytes: requestResult transferredBytes.
	
	^requestResult returnValue
]

{ #category : #initialization }
SeamlessRequestResultDelivery >> initialize [
	super initialize.
	
	synchronizationSemaphore := Semaphore new
]

{ #category : #accessing }
SeamlessRequestResultDelivery >> requestResult [
	^ requestResult
]

{ #category : #accessing }
SeamlessRequestResultDelivery >> senderPeer [
	^ senderPeer
]

{ #category : #accessing }
SeamlessRequestResultDelivery >> senderPeer: anObject [
	senderPeer := anObject
]

{ #category : #delivery }
SeamlessRequestResultDelivery >> shipResult: aRequestResult [

	requestResult := aRequestResult.
	synchronizationSemaphore signal
]

{ #category : #private }
SeamlessRequestResultDelivery >> waitResult [
	synchronizationSemaphore wait
]
