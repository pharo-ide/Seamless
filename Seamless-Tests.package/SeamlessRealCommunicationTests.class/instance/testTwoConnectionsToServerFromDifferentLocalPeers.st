tests
testTwoConnectionsToServerFromDifferentLocalPeers
 
	| remotePeerForClient1 client2Network remotePeerForClient2 |
	remotePeerForClient1 := self connectToServerPeer.
	client2Network := self networkClass new.
	remotePeerForClient2 := client2Network remotePeerAt: self serverAddress.
	self forkAndWait: [remotePeerForClient1 establishNewConnection. 
			remotePeerForClient2 establishNewConnection].

	serverSideNetwork connectionsCount should be: 2.
	serverSideNetwork remotePeers should haveSize: 2.
	serverSideNetwork remotePeers first connectionsCount should be: 1.
	serverSideNetwork remotePeers last connectionsCount should be: 1.	