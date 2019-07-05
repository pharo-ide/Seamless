Class {
	#name : #SeamlessDistributedObjectsTests,
	#superclass : #TestCase,
	#instVars : [
		'distributedObjects',
		'network'
	],
	#category : 'Seamless-Tests'
}

{ #category : #running }
SeamlessDistributedObjectsTests >> setUp [
	super setUp.
	
	network := SeamlessNetwork new.
	distributedObjects := SeamlessDistributedObjects over: network
]

{ #category : #tests }
SeamlessDistributedObjectsTests >> testGettingLocalObjectByReferenceId [

	| actual |

	distributedObjects objectsToReferences 
		at: #object1 put: (SeamlessObjectReference id: #givenId peer: BasysLocalPeer new).
	distributedObjects objectsToReferences 
		at: #object2 put: (SeamlessObjectReference id: #givenId peer: BasysActiveRemotePeer new).
	distributedObjects objectsToReferences 
		at: #object3 put: (SeamlessObjectReference id: #wrongId peer: BasysLocalPeer new).

	actual := distributedObjects localForReferenceId: #givenId.
		
	actual should be: #object1
]

{ #category : #tests }
SeamlessDistributedObjectsTests >> testGettingLocalObjectByReferenceIdWhenItNotExists [

	[distributedObjects localForReferenceId: #givenId] should raise: KeyNotFound
]

{ #category : #tests }
SeamlessDistributedObjectsTests >> testGettingNewReferencesShouldGenerateNewReferenceIds [

	| reference1 reference2 |
	
	reference1 := distributedObjects referenceFor: Object new ifNewUse: [SeamlessObjectReference new].
	reference2 := distributedObjects referenceFor: Object new ifNewUse: [SeamlessObjectReference new].	
		
	reference1 id should not equal: reference2 id
]

{ #category : #tests }
SeamlessDistributedObjectsTests >> testGettingObjectByReferenceWhenItAbsent [

	| actual reference |
	reference := SeamlessObjectReference id: #testId peerId: #testPeer.
	actual := distributedObjects at: reference ifAbsentUseProxy: [#proxy].
		
	actual should be: #proxy.
	distributedObjects objectsToReferences should include: reference at: #proxy.
	distributedObjects referencesToObjects should include: #proxy at: reference.
]

{ #category : #tests }
SeamlessDistributedObjectsTests >> testGettingObjectByReferenceWhenItExists [

	| actual |
	
	distributedObjects referencesToObjects 
		at: (SeamlessObjectReference id: #id peerId: #peerId) put: #result.

	actual := distributedObjects 
		at: (SeamlessObjectReference id: #id peerId: #peerId)
		ifAbsentUseProxy: Any.
		
	actual should be: #result
]

{ #category : #tests }
SeamlessDistributedObjectsTests >> testGettingReferenceForExistedObject [

	| object reference |
	object := Object new.
	
	distributedObjects objectsToReferences at: object put: #reference.
	
	reference := distributedObjects referenceFor: object ifNewUse: [self error: 'existing reference should be returned'].
	
	reference should be: #reference
]

{ #category : #tests }
SeamlessDistributedObjectsTests >> testGettingReferenceForNewObject [

	| object reference  actual |
	reference := SeamlessObjectReference new.
	object := Mock new.
	
	actual := distributedObjects referenceFor: object ifNewUse: [reference].
	
	actual should be: reference.
	reference senderPeer should be: network localPeer.
	reference ownerPeerId should be: network localPeerId.
	distributedObjects objectsToReferences should include: reference at: object.
	distributedObjects referencesToObjects should include: object at: reference.	
]

{ #category : #tests }
SeamlessDistributedObjectsTests >> testGettingSize [

	| object |

	object := Object new.
	
	distributedObjects referenceFor: object ifNewUse: [ SeamlessObjectReference new ].
	
	distributedObjects should haveSize: 1
]

{ #category : #tests }
SeamlessDistributedObjectsTests >> testHasEmptyObjectsToReferencesMapByDefault [

	distributedObjects objectsToReferences should be isEmpty
]

{ #category : #tests }
SeamlessDistributedObjectsTests >> testHasEmptyReferencesToObjectsMapByDefault [

	distributedObjects referencesToObjects should be isEmpty
]

{ #category : #tests }
SeamlessDistributedObjectsTests >> testRemoveAbsentObject [

	| object |

	object := Object new.
		
	distributedObjects remove: object.
	
	distributedObjects objectsToReferences should be isEmpty.
	distributedObjects referencesToObjects should be isEmpty
]

{ #category : #tests }
SeamlessDistributedObjectsTests >> testRemoveObject [

	| object |

	object := Object new.
	
	distributedObjects referenceFor: object ifNewUse: [ SeamlessObjectReference new ].
		
	distributedObjects remove: object.
	
	distributedObjects objectsToReferences should be isEmpty.
	distributedObjects referencesToObjects should be isEmpty
]

{ #category : #tests }
SeamlessDistributedObjectsTests >> testRemovingObjectsDistributedByParticularPeer [

	| peer |
	peer := BasysPassiveRemotePeer new.
	distributedObjects objectsToReferences 
		at: #object1 put: (SeamlessObjectReference id: #id1 peer: BasysLocalPeer new).
	distributedObjects objectsToReferences 
		at: #object2 put: (SeamlessObjectReference id: #id2 peer: BasysActiveRemotePeer new).
	distributedObjects objectsToReferences 
		at: #object3 put: (SeamlessObjectReference id: #id3 peer: peer).
	distributedObjects objectsToReferences 
		at: #object4 put: (SeamlessObjectReference id: #id4 peer: peer).
	
	distributedObjects referencesToObjects 
		at: (SeamlessObjectReference id: #id3 peer: peer) put: #object3.
	distributedObjects referencesToObjects 
		at: (SeamlessObjectReference id: #id4 peer: peer) put: #object4.
			
	distributedObjects removeObjectsDistributedBy: peer.
		
	distributedObjects referencesToObjects should be isEmpty.
	distributedObjects objectsToReferences should not includeKey: #object3.
	distributedObjects objectsToReferences should not includeKey: #object4.
]
