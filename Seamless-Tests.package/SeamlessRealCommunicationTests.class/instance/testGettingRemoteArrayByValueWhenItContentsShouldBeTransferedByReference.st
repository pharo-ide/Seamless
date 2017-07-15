tests
testGettingRemoteArrayByValueWhenItContentsShouldBeTransferedByReference
 
	| remoteClass remoteCollection remoteEnv remoteRect |
	
	serverSideNetwork transferByReference: (Instance of: Rectangle).
	serverSideNetwork transferByValue: (Instance of: Array).
 
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Array.
		remoteRect := (remoteEnv at: #Rectangle) left: 0 right: 0 top: 20 bottom: 10.
		remoteCollection := remoteClass with: remoteRect ].

	remoteCollection should beInstanceOf: Array.
	remoteCollection first should beInstanceOf: SeamlessProxy 