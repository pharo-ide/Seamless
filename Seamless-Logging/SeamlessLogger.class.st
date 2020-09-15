"
I log all seamless requests and allow to collect statistics over them for following analysis.

Public API and Key Messages

- startAfresh - create new default instance which clean all logs in past
- start - turn on logging by installing requests interception meta links into Seamless code
- stop - turn off logging. It removes all installed meta links
- collectStatistics - returns statistics instance for communication analysis

Internal Representation and Key Implementation Points.

    Instance Variables
	outgoingLink:		<Metalink>
	incomingLink:		<Metalink>
	isRunning:		<Boolean>	
	requests:		<OrderedCollection of <SeamlessRequest>>


    Implementation Points
"
Class {
	#name : #SeamlessLogger,
	#superclass : #Object,
	#instVars : [
		'incomingLink',
		'outgoingLink',
		'requests',
		'isRunning'
	],
	#classInstVars : [
		'default'
	],
	#category : 'Seamless-Logging'
}

{ #category : #controlling }
SeamlessLogger class >> collectStatistics [
	^default collectStatistics
]

{ #category : #accessing }
SeamlessLogger class >> default [
	^ default
]

{ #category : #accessing }
SeamlessLogger class >> default: anObject [
	default := anObject
]

{ #category : #testing }
SeamlessLogger class >> isRunning [
	^default notNil and: [default isRunning]
]

{ #category : #controlling }
SeamlessLogger class >> start [
	default ifNil: [ default := SeamlessLogger new].
	default start
]

{ #category : #controlling }
SeamlessLogger class >> startAfresh [

	self stop.
	
	default := SeamlessLogger new.
	self start.
]

{ #category : #controlling }
SeamlessLogger class >> stop [
	default ifNotNil: [ default stop ]
]

{ #category : #controlling }
SeamlessLogger class >> stopAndClean [
	self stop.
	self default: nil
]

{ #category : #controlling }
SeamlessLogger >> collectStatistics [

	| needsResume stat |
	needsResume := self isRunning.
	self stop.

	stat := SeamlessStatistics buildOn: requests.
	
	needsResume ifTrue: [ self start].
	^stat
]

{ #category : #initialization }
SeamlessLogger >> initialize [
	super initialize.
	isRunning := false.
	requests := OrderedCollection new: 2000.
	outgoingLink := MetaLink new 
		metaObject: self; 
		selector: #interceptOutgoingRequest:;
		arguments: #(arguments).
	incomingLink := MetaLink new 
		metaObject: self; 
		selector: #logIncomingRequest:;
		arguments: #(receiver)
]

{ #category : #logging }
SeamlessLogger >> interceptOutgoingRequest: requestAndConnection [

	self logOutgoingRequest: requestAndConnection first
]

{ #category : #testing }
SeamlessLogger >> isRunning [

	^isRunning
]

{ #category : #logging }
SeamlessLogger >> log: aSeamlessRequest [
	aSeamlessRequest class = SeamlessDeliverResultRequest ifTrue: [ ^self ].
	
	requests add: aSeamlessRequest.
	Transcript crShow: aSeamlessRequest printMessageForLog; flush.
]

{ #category : #logging }
SeamlessLogger >> logIncomingRequest: aSeamlessRequest [
	
	self log: aSeamlessRequest
]

{ #category : #logging }
SeamlessLogger >> logOutgoingRequest: aSeamlessRequest [

	self log: aSeamlessRequest
]

{ #category : #controlling }
SeamlessLogger >> start [

	(SeamlessNetwork>>#sendObject:by:) ast link: outgoingLink.		
	(SeamlessEvaluationRequest>>#executeFor:) ast link: incomingLink.
	
	isRunning := true
]

{ #category : #controlling }
SeamlessLogger >> stop [

	incomingLink ifNotNil: [ incomingLink uninstall ].
	outgoingLink ifNotNil: [ outgoingLink uninstall ].
	isRunning := false
]
