"
I represent thread safe collection of distributed objects.
I contain all objects which transfered by network as reference.

I has two dictionaries:
	- objectsToReference provide fast access to reference for concrete object
	- referencesToObject provide fast access to object by it reference

Public API and Key Messages

- at: aSeamlessReference
returns objects by it reference. If no found I create proxy representation for it.

- referenceFor: anObject receivedFrom: aBasysRemotePeer
returnes reference for given object. If not found I create it and bound it to given sender peer

    Instance Variables
	lastReferenceId:		<Integer>
	lock:		<ReadWriteLock>
	objectsToReferences:		<IdentityDictionary>
	referencesToObjects:		<Dictionary>
"
Class {
	#name : #SeamlessDistributedObjects,
	#superclass : #Object,
	#instVars : [
		'network',
		'lock',
		'objectsToReferences',
		'referencesToObjects',
		'lastReferenceId'
	],
	#category : 'Seamless-Core'
}

{ #category : #'instance creation' }
SeamlessDistributedObjects class >> over: aSeamlessNetwork [

	^self new 
		network: aSeamlessNetwork 
]

{ #category : #accessing }
SeamlessDistributedObjects >> at: aSeamlessObjectReference ifAbsentUseProxy: proxyBlock [
	| object |
	object := lock criticalRead: [ referencesToObjects at: aSeamlessObjectReference ifAbsent: [ nil ] ].
	object ifNil: [ 
		aSeamlessObjectReference ownerPeerId = network localPeerId 
				ifTrue: [ ^SeamlessMissingObject referencedBy: aSeamlessObjectReference ].
				
		lock criticalWrite: [ 
			object := proxyBlock value.
			objectsToReferences at: object put: aSeamlessObjectReference.
			referencesToObjects at: aSeamlessObjectReference put: object ]
	].

	^object
]

{ #category : #accessing }
SeamlessDistributedObjects >> at: aSeamlessObjectReference ifPresent: presentBlock ifAbsentUseProxy: proxyBlock [
	| object |
	object := lock criticalRead: [ referencesToObjects at: aSeamlessObjectReference ifAbsent: [ nil ] ].
	
	(object isNil and: [aSeamlessObjectReference ownerPeerId = network localPeerId])
		ifTrue: [ object := SeamlessMissingObject referencedBy: aSeamlessObjectReference ].
				
	object 
		ifNotNil: presentBlock
		ifNil: [ 	lock criticalWrite: [ 
			object := proxyBlock value.
			objectsToReferences at: object put: aSeamlessObjectReference.
			referencesToObjects at: aSeamlessObjectReference put: object ]
	].

	^object
]

{ #category : #accessing }
SeamlessDistributedObjects >> clear [
	lock criticalWrite: [ 
		objectsToReferences removeAll.
		referencesToObjects removeAll]
]

{ #category : #private }
SeamlessDistributedObjects >> createNewReferenceFor: anObject by: refCreationBlock [
	"it should be called inside lock critical section"
	
	| reference |
	anObject isSeamlessProxy ifTrue: [ 
		"it is case when alien proxy (form another network on this image) is transfered inside this current network (which is not connected to proxy one)"
		^anObject seamlessReference ].
	
	reference := refCreationBlock value.
	
	reference 
		id: (lastReferenceId := lastReferenceId + 1);
		ownerPeerId: network localPeerId;
		senderPeer: network localPeer.
		
	^reference
]

{ #category : #testing }
SeamlessDistributedObjects >> includesReference: aSeamlessObjectReference [ 
	^lock criticalRead: [ referencesToObjects includesKey: aSeamlessObjectReference]
]

{ #category : #initialization }
SeamlessDistributedObjects >> initialize [
	super initialize.
	
	lock := ReadWriteLock new.
	lastReferenceId := 0.
	objectsToReferences := IdentityDictionary new.
	referencesToObjects := Dictionary new.
]

{ #category : #testing }
SeamlessDistributedObjects >> isEmpty [
	^referencesToObjects isEmpty
]

{ #category : #accessing }
SeamlessDistributedObjects >> localForReferenceId: id [ 
	| reference |
	reference := objectsToReferences keysAndValuesDo: [ :o :ref | 
		(ref id = id and: [ ref senderPeer class = BasysLocalPeer ])
			ifTrue: [ ^o ]].
	
	KeyNotFound signalFor: id in: self 
]

{ #category : #accessing }
SeamlessDistributedObjects >> network [
	^ network
]

{ #category : #accessing }
SeamlessDistributedObjects >> network: anObject [
	network := anObject
]

{ #category : #accessing }
SeamlessDistributedObjects >> objectsToReferences [
	^ objectsToReferences
]

{ #category : #accessing }
SeamlessDistributedObjects >> objectsToReferences: anObject [
	objectsToReferences := anObject
]

{ #category : #printing }
SeamlessDistributedObjects >> printOn: aStream [
	super printOn: aStream.
	aStream << '(' << self size << ')'
]

{ #category : #accessing }
SeamlessDistributedObjects >> referenceFor: anObject ifNewUse: refCreationBlock [
	| reference |
	(anObject isSeamlessProxy and: [ anObject seamlessReference ownerPeerId = network localPeerId])
		ifTrue: [ "it is special case when we have two connected network instances on same image and we try to send client proxy from server to client (or otherwise)"			
			^anObject seamlessReference ].
	
	reference := lock criticalRead: [ objectsToReferences at: anObject ifAbsent: [ nil ] ].
	reference ifNil: [ 
		lock criticalWrite: [ 
			reference := self createNewReferenceFor: anObject by: refCreationBlock.
			objectsToReferences at: anObject put: reference.
			referencesToObjects at: reference put: anObject ]
	].

	^reference
]

{ #category : #accessing }
SeamlessDistributedObjects >> referencesToObjects [
	^ referencesToObjects
]

{ #category : #accessing }
SeamlessDistributedObjects >> referencesToObjects: anObject [
	referencesToObjects := anObject
]

{ #category : #accessing }
SeamlessDistributedObjects >> remove: anObject [ 
	| reference |
	lock criticalWrite: [ 
		reference := objectsToReferences removeKey: anObject ifAbsent: [^self].
		referencesToObjects removeKey: reference]
]

{ #category : #accessing }
SeamlessDistributedObjects >> removeAt: aSeamlessObjectReference [ 
	| object |
	lock criticalWrite: [
		object := referencesToObjects removeKey: aSeamlessObjectReference.
		objectsToReferences removeKey: object]
]

{ #category : #accessing }
SeamlessDistributedObjects >> removeObjectsDistributedBy: aRemotePeer [
	
	| references |
	lock criticalRead: [ 
		references := objectsToReferences select: [ :each |
			each senderPeer == aRemotePeer ]].
	lock criticalWrite: [ 
		references do: [ :each | | object |
			object := referencesToObjects removeKey: each.
			objectsToReferences removeKey: object]
	]
]

{ #category : #accessing }
SeamlessDistributedObjects >> size [
	^referencesToObjects size
]
