tests
testGettingRemoteObjectAsDeepCopy
 
	| remoteEnv result remoteClass |
	
	serverSideNetwork transferByDeepCopy: (Instance of: Rectangle).
	
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Rectangle.
		result := remoteClass left: 0 right: 10 top: 0 bottom: 20].

	result should beInstanceOf: Rectangle.
	result origin should beInstanceOf: Point.
	result corner should beInstanceOf: Point.