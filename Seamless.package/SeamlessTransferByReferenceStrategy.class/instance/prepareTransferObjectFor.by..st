operations
prepareTransferObjectFor: anObject by: anObjectTransporter
 
	| reference |
	reference := anObjectTransporter referenceFor: anObject.
	
	cachedMessages do: [ :each | 
		reference cacheMessage: each with: (anObject perform: each)].
	
	^reference