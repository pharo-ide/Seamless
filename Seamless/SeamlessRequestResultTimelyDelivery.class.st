"
I represent a delivery of request results which restricted in time using specified timeout, #maxTime.
 
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
SeamlessRequestResultTimelyDelivery class >> maxTime: aDuration [
	^self new 
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
	| timeout |
	timeout := synchronizationSemaphore wait: maxTime.
	timeout ifTrue: [ SeamlessRequestTimeout signal ]
]
