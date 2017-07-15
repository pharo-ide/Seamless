tests
testGettingEnvironmentFromAddressWhenPassivePeerAlreadyExistsForIt
 		
	| remoteEnv |
	self forkAndWait: [
		clientSideNetwork environmentAt: self serverAddress.
		"here serverside has passive peer which present client.
		Now we set up server to interract with client network and ask server network for the remote environment from client"
		server network: clientSideNetwork.
		remoteEnv := serverSideNetwork environmentAt: self serverAddress].

	remoteEnv isSeamlessProxy should be: true.
	serverSideNetwork remotePeers should haveSize: 1.
	serverSideNetwork remotePeers anyOne should beInstanceOf: BasysActiveRemotePeer.
	serverSideNetwork remotePeers anyOne address should equal: self serverAddress.
	remoteEnv seamlessReference senderPeer should be: serverSideNetwork remotePeers anyOne.