tests
testGettingRemoteSetByValueWhenItContentsShouldBeTransferedByReference
 
	| remoteClass remoteCollection remoteEnv remoteRect |
	
	serverSideNetwork transferByReference: (Instance of: Rectangle).
	serverSideNetwork transferByValue: (Instance of: Set).
 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Set.
		remoteRect := (remoteEnv at: #Rectangle) left: 0 right: 0 top: 20 bottom: 10.
		remoteCollection := remoteClass with: remoteRect ].

	remoteCollection should beInstanceOf: Set.
	remoteCollection anyOne should beInstanceOf: SeamlessProxy 