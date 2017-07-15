tests
testTwoConnectionsToServerFromSameLocalPeer
 
	| remotePeer |
	remotePeer := self connectToServerPeer.
	self forkAndWait: [remotePeer establishNewConnection; establishNewConnection].

	serverSideNetwork connectionsCount should be: 2.
	clientSideNetwork connectionsCount should be: 2.
	serverSideNetwork remotePeers should haveSize: 1
	