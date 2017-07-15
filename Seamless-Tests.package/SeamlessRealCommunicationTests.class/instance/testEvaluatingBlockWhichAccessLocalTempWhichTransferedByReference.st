tests
testEvaluatingBlockWhichAccessLocalTempWhichTransferedByReference
	| remotePeer result rect |
	remotePeer := self connectToServerPeer.
	clientSideNetwork transferByReference: (Instance of: Rectangle).
	rect := 0@0 corner: 2@3.	
	
	self forkAndWait: [
		result := remotePeer evaluate: [ rect area ].
	]. 
 
	result should be: 6