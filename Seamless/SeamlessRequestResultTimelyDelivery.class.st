"
I represent a result delivery restricted in time using specified timeout, #maxTime.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	maxTime:		<Duration>
"
Class {
	#name : #SeamlessRequestResultTimelyDelivery,
	#superclass : #SeamlessRequestResultDelivery,
	#instVars : [
		'maxTime'
	],
	#category : #'Seamless-Requests'
}

{ #category : #'instance creation' }
SeamlessRequestResultTimelyDelivery class >> from: aRemotePeer maxTime: aDuration [
	^(self from: aRemotePeer)
		maxTime: aDuration
]

{ #category : #accessing }
SeamlessRequestResultTimelyDelivery >> maxTime [
	^ maxTime
]

{ #category : #accessing }
SeamlessRequestResultTimelyDelivery >> maxTime: anObject [
	maxTime := anObject
]

{ #category : #private }
SeamlessRequestResultTimelyDelivery >> waitResult [
	"Instead of blindly wait for delivery result for specified maxTime 
	we periodically check the connection status
	and consider the deliver as unavailable when senderPeer is not connected anymore.
	So we fail as soon as senderPeer losts connection which improves responsiveness in bad scenarios"
	| startTime |
	startTime := DateAndTime now.
	
	[DateAndTime now - startTime < maxTime 
		and: [ requestResult isNil and: [ senderPeer isConnected ]] ]
			whileTrue: [ synchronizationSemaphore wait: 100 milliSeconds].
		
	requestResult ifNil: [ 
		DateAndTime now - startTime >= maxTime 
			ifTrue: [ SeamlessRequestTimeout signal ]
			ifFalse: [ SeamlessResultDeliveryUnavailable signal ]
	]
]
