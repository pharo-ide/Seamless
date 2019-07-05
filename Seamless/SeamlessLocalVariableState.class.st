"
I represent local state of some variabe object.
I am used by Seamless-GTSupport tools to implemented SeamlessRemoteWorkspaceVariable which keeps local cache of value locally and updates remote state at same time. 

I am always transferred by value and cache locally all modification of variable or updates of variable value from remote side of remote variable.	
When there is connection with remote side of variable I perform remote messages to update state of variable on remote side.
For write operation I perform asinchronous message send to update client.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	remoteVariable:		<SeamlessRemoteWorkspaceVariable>
	value:		<Object>
"
Class {
	#name : #SeamlessLocalVariableState,
	#superclass : #SeamlessTransferObject,
	#instVars : [
		'remoteVariable',
		'value',
		'isAssigned'
	],
	#category : 'Seamless-Core'
}

{ #category : #'instance creation' }
SeamlessLocalVariableState class >> of: aRemoteVariable [
	^self new 
		remoteVariable: aRemoteVariable
]

{ #category : #testing }
SeamlessLocalVariableState >> checkConnection [
	remoteVariable ifNil: [ ^false].
	
	remoteVariable remotePeer isConnected ifTrue: [ ^true ].
	remoteVariable := nil.
	^false
]

{ #category : #initialization }
SeamlessLocalVariableState >> initialize [
	super initialize.
	
	isAssigned := false
]

{ #category : #accessing }
SeamlessLocalVariableState >> isAssigned [
	^ isAssigned
]

{ #category : #accessing }
SeamlessLocalVariableState >> isAssigned: anObject [
	isAssigned := anObject
]

{ #category : #testing }
SeamlessLocalVariableState >> isUnassigned [

	^isAssigned not
]

{ #category : #accessing }
SeamlessLocalVariableState >> prepareValueTransferBy: aSeamlessObjectTransporter [

	remoteVariable ifNotNil: [ 
		aSeamlessObjectTransporter transferByReference: remoteVariable]
]

{ #category : #accessing }
SeamlessLocalVariableState >> read [

	self checkConnection ifFalse: [ ^value].
	
	self isUnassigned ifTrue: [ 
		self value: remoteVariable read.
		^value].

	^self readRemoteValue
]

{ #category : #accessing }
SeamlessLocalVariableState >> readRemoteValue [
	"It is possible that remote request will be delivered to remote side but response will hangs.
	We should setup timeout in that case and ignore possible value update"
	
	[
		[value := remoteVariable read] ifError: [  ]
	] valueWithin: 2 seconds onTimeout: [].
	
	^value
]

{ #category : #accessing }
SeamlessLocalVariableState >> remoteVariable [
	^ remoteVariable
]

{ #category : #accessing }
SeamlessLocalVariableState >> remoteVariable: anObject [
	remoteVariable := anObject
]

{ #category : #accessing }
SeamlessLocalVariableState >> value [

	^value
]

{ #category : #accessing }
SeamlessLocalVariableState >> value: anObject [

	value := anObject.
	isAssigned := true
]

{ #category : #accessing }
SeamlessLocalVariableState >> write: anObject [
	| writeMessage |
	self value: anObject.
	self checkConnection ifFalse: [ ^anObject].
	
	writeMessage := MessageSend receiver: remoteVariable selector: #write: argument: anObject.
	[remoteVariable remotePeer 
		sendDataPacket: (SeamlessMessageSendRequest with: writeMessage)] ifError: [  ].
	^anObject.
]
