operations
prepareTransferObjectFor: anObject by: anObjectTransporter
 
	| reference |
	reference := anObjectTransporter referenceFor: anObject.
	reference pointsToRemoteObject ifTrue: [ 
		"no need for cache when we just return existing remote reference to another peer
		which can be also owner peer which sent cached properties here"
		^reference ]. 
	
	cachedMessages do: [ :each | 
		reference cacheMessage: each with: (anObject perform: each)].
	
	^reference