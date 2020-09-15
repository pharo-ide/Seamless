"
I represent reference to copy of distributed object. On remote side I represent my object with copy and when this copy is transferred back to owner it will be original object.
For now changes on copy on remote side will be not synchronized with original owner object

Internal Representation and Key Implementation Points.

    Instance Variables
	objectCopy:		<Object>
"
Class {
	#name : #SeamlessObjectCopyReference,
	#superclass : #SeamlessObjectReference,
	#instVars : [
		'objectCopy'
	],
	#category : 'Seamless-Core'
}

{ #category : #'instance creation' }
SeamlessObjectCopyReference class >> to: anObject [
	^self new 
		objectCopy: anObject copy
]

{ #category : #'proxy creation' }
SeamlessObjectCopyReference >> createProxy [
	^objectCopy
]

{ #category : #'travel guide support' }
SeamlessObjectCopyReference >> hasRemoteProperties [
	^true
]

{ #category : #accessing }
SeamlessObjectCopyReference >> objectCopy [
	^ objectCopy
]

{ #category : #accessing }
SeamlessObjectCopyReference >> objectCopy: anObject [
	objectCopy := anObject
]

{ #category : #transfer }
SeamlessObjectCopyReference >> prepareLocalSubstitutionIn: aSeamlessNetwork with: aSeamlessTransporter [
	| representation |
	objectCopy := aSeamlessTransporter readNextObject.
	
	self == objectCopy ifFalse: [ 
		"It happens when aSeamlessTransporter substitutes given object with another object 
		which references the original object itself. 
		In this case on the remote side the materialized object will reference itself. 
		Here it is ObjectCopyReference which references itself in objectCopy variable. 
		So we dont need to visit objectCopy because we already here and it will broke protocol.
		In future we need to support correct serialization of such substitutions:
		- inside the substitution subgraph the original object must be serialized without substitution. 
		It also will allow the automatic synchronization of the object state on the client 
		when same object is received from the server multiple times".
		aSeamlessTransporter atNextStepProcess: objectCopy].		
	
	representation := aSeamlessNetwork objectFor: self.	
			
	^representation
]

{ #category : #transfer }
SeamlessObjectCopyReference >> prepareValueTransferBy: aSeamlessTransporter [
	super prepareValueTransferBy: aSeamlessTransporter.
	
	aSeamlessTransporter transferByValue: objectCopy 
]

{ #category : #'travel guide support' }
SeamlessObjectCopyReference >> remotePropertiesSize [
	^1
]

{ #category : #'travel guide support' }
SeamlessObjectCopyReference >> remotePropertyAt: index [
	^objectCopy
]

{ #category : #'travel guide support' }
SeamlessObjectCopyReference >> remotePropertyAt: index put: newObject [
	objectCopy := newObject
]
