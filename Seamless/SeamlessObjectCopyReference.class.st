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
SeamlessObjectCopyReference >> prepareLocalSubstitutionIn: aSeamlessNetwork with: aTostMaterialization [
	| representation |
	objectCopy := aTostMaterialization readNextObject.
	
	self == objectCopy ifFalse: [ 
		"It happens when Tost serialization substitutes object with another object 
		which reference original object itself. In this case on remote side materialized object 
		will reference itself. 
		Here it is ObjectCopyReference which references itself in objectCopy variable. 
		So we dont need to visit objectCopy because we already here and it will broke protocol.
		In future we need to support correct serialization of such substitutions. 
		So inside substitution subgraph original object will be serialized without substitution. 
		It also will allow automatic synchronization of object state on client 
		when same object will be received from server few times".
		aTostMaterialization atNextStepProcess: objectCopy].		
	
	representation := aSeamlessNetwork objectFor: self.	
			
	^representation
]

{ #category : #transfer }
SeamlessObjectCopyReference >> prepareValueTransferBy: anObjectTransporter [
	super prepareValueTransferBy: anObjectTransporter.
	
	anObjectTransporter transferByValue: objectCopy 
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
