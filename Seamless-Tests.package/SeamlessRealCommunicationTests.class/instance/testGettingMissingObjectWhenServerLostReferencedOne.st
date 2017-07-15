tests
testGettingMissingObjectWhenServerLostReferencedOne
 
	| remoteEnv actual |
	 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		10 milliSeconds wait.
		serverSideNetwork removeDistributedObject: Smalltalk.
		serverSideNetwork distributedObjects should be isEmpty.
		actual := remoteEnv asLocalObject 
	]. 

	actual should beInstanceOf: SeamlessMissingObject.
	actual reference should equal: remoteEnv seamlessReference