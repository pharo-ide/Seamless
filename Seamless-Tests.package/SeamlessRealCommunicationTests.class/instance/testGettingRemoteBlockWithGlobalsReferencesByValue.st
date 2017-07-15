tests
testGettingRemoteBlockWithGlobalsReferencesByValue
	| remoteBlock localBlock transferedBlock |
	transferedBlock := [OrderedCollection with: 10].
	serverSideNetwork transferByReference: (Kind of: OrderedCollection).
	remoteBlock := self prepareClientProxyForServerObject: transferedBlock.
	
	self forkAndWait: [
		localBlock := remoteBlock asLocalObject
	]. 
 
	localBlock should beKindOf: BlockClosure.
	localBlock sourceNode formattedCode should equal: transferedBlock sourceNode formattedCode.
	localBlock value should equal: #(10) asOrderedCollection 