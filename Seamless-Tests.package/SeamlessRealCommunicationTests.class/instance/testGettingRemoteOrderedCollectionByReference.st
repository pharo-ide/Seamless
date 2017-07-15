tests
testGettingRemoteOrderedCollectionByReference
 
	| remoteClass remoteCollection remoteEnv |
	
	serverSideNetwork transferByReference: (Instance of: OrderedCollection).
	
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #OrderedCollection.
		remoteCollection := remoteClass new: 3 withAll: #testValue ].

	remoteCollection should beInstanceOf: SeamlessProxy 