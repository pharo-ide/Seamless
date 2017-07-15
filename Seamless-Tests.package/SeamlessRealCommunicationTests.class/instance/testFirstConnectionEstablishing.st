tests
testFirstConnectionEstablishing
 
	| remotePeer |
	remotePeer := self connectToServerPeer.
	self forkAndWait: [remotePeer establishNewConnection].

	serverSideNetwork connectionsCount should be: 1.
	clientSideNetwork connectionsCount should be: 1
	