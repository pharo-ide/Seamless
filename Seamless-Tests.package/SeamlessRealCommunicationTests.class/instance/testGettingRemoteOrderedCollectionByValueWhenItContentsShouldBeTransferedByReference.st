tests
testGettingRemoteOrderedCollectionByValueWhenItContentsShouldBeTransferedByReference
 
	| remoteClass remoteCollection remoteEnv remoteRect |	
	serverSideNetwork transferByReference: (Instance of: Rectangle).
	serverSideNetwork transferByValue: (Instance of: OrderedCollection).
 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #OrderedCollection.
		remoteRect := (remoteEnv at: #Rectangle) left: 0 right: 0 top: 20 bottom: 10.
		remoteCollection := remoteClass with: remoteRect ].

	remoteCollection should beInstanceOf: OrderedCollection.
	remoteCollection first should beInstanceOf: SeamlessProxy 