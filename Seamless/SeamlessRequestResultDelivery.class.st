"
I am a helper object to manage a delivery of result inside SeamlessSyncRequestContext.

From the one side users which need a result should ask me for:

	delivery deliverResultFor: aRequest
	
which will wait until the result will be finally delivered. When it will happen I will return actual result value from this method. aRequest will receive transferredBytes for statistics. 

From the other side users which have a result should send it through me using: 

	deliver deliverResult: aRequestResult 
	
where I will signal all waiting users that the result is ready using my synchronizationSemaphore.

Internal Representation and Key Implementation Points.

    Instance Variables
	requestResult:		<SeamlessRequestResult>
	synchronizationSemaphore:		<Semaphore>
"
Class {
	#name : #SeamlessRequestResultDelivery,
	#superclass : #Object,
	#instVars : [
		'synchronizationSemaphore',
		'requestResult'
	],
	#category : #'Seamless-Requests'
}

{ #category : #delivery }
SeamlessRequestResultDelivery >> deliverResult: aRequestResult [

	requestResult := aRequestResult.
	synchronizationSemaphore signal
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

{ #category : #private }
SeamlessRequestResultDelivery >> waitResult [
	synchronizationSemaphore wait
]
