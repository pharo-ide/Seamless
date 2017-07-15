tests
testGettingRemoteBlockWithoutObjectReferencesByValue
	| remoteBlock localBlock transferedBlock |
	transferedBlock := [ 1 + 2 ].
	remoteBlock := self prepareClientProxyForServerObject: transferedBlock.
	
	self forkAndWait: [
		localBlock := remoteBlock asLocalObject
	]. 
 
	localBlock should beKindOf: BlockClosure.
	localBlock sourceNode formattedCode should equal: transferedBlock sourceNode formattedCode.
	localBlock value should equal: 3