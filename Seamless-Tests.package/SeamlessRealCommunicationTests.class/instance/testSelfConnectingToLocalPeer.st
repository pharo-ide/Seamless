tests
testSelfConnectingToLocalPeer
 
	| remotePeer |
	remotePeer := serverSideNetwork remotePeerAt: self serverAddress.
	self forkAndWait: [remotePeer establishNewConnection].

	serverSideNetwork connectionsCount should be: 2.
	serverSideNetwork remotePeers should haveSize: 1.
	serverSideNetwork remotePeers anyOne should beInstanceOf: BasysActiveRemotePeer 