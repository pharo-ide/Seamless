"
I am strategy which transfer objects by reference. It means that kind of SeamlessReference will be sent between peers.

I have default instance:
	SeamlessTransferStrategy defaultByReference
"
Class {
	#name : #SeamlessTransferByReferenceStrategy,
	#superclass : #SeamlessTransferStrategy,
	#instVars : [
		'cachePolicy',
		'cachedMessages'
	],
	#category : 'Seamless-Transport'
}

{ #category : #'instance creation' }
SeamlessTransferByReferenceStrategy class >> for: criteria withCacheFor: selectors [ 
	^(self for: criteria) 
		cachedMessages: selectors
]

{ #category : #accessing }
SeamlessTransferByReferenceStrategy >> cachedMessages [
	^cachedMessages
]

{ #category : #accessing }
SeamlessTransferByReferenceStrategy >> cachedMessages: selectors [
	cachedMessages := selectors
]

{ #category : #initialization }
SeamlessTransferByReferenceStrategy >> initialize [
	super initialize.
	
	cachedMessages := Array empty
]

{ #category : #operations }
SeamlessTransferByReferenceStrategy >> prepareTransferObjectFor: anObject by: anObjectTransporter [
 
	| reference |
	reference := anObjectTransporter referenceFor: anObject.
	reference pointsToRemoteObject ifTrue: [ 
		"no need for cache when we just return existing remote reference to another peer
		which can be also owner peer which sent cached properties here"
		^reference ]. 
	
	cachedMessages do: [ :each | 
		reference cacheMessage: each with: (anObject perform: each)].
	
	^reference
]
