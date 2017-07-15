tests
testGettingMissingObjectAsPartOfAnotherObject
	| remoteEnv point array |
	serverSideNetwork transferByReference: (Instance of: Point).
	serverSideNetwork transferByValue: (Instance of: Array).
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		point := (remoteEnv at: #Point) x: 10 y: 20.
		serverSideNetwork distributedObjects removeAt: point seamlessReference.
		
		array := (remoteEnv at: #Array) with: point.
	]. 

	array first should beInstanceOf: SeamlessMissingObject.
	array first reference should equal: point seamlessReference.
	serverSideNetwork distributedObjects should not be includesReference: point seamlessReference