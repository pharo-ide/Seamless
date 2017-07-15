tests
testTwiceConnectionEstablishing
 
	| remotePeer |
	remotePeer := self connectToServerPeer.
	self forkAndWait: [
		remotePeer establishNewConnection.
		remotePeer establishNewConnection].

	serverSideNetwork connectionsCount should be: 2.
	clientSideNetwork connectionsCount should be: 2
	