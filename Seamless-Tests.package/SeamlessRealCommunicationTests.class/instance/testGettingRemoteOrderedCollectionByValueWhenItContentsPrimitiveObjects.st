tests
testGettingRemoteOrderedCollectionByValueWhenItContentsPrimitiveObjects
 
	| remoteClass remoteCollection remoteEnv |
	
	serverSideNetwork transferByValue: (Instance of: OrderedCollection).
	
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #OrderedCollection.
		remoteCollection := remoteClass new: 3 withAll: #testValue ].

	remoteCollection should not be isSeamlessProxy.
	"Fuel always transfers internal array of OrderedCollection as value"
	(remoteCollection instVarNamed: 'array') should not be isSeamlessProxy.
	remoteCollection should equal: #(testValue testValue testValue)