tests
testGettingRemoteClassBinding
 
	| result remoteClass remoteEnv |
			
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Rectangle.
		result := remoteClass binding  ].

	result should beInstanceOf: Rectangle binding class.
	result key should equal: Rectangle binding key.
	result value should beInstanceOf: SeamlessProxy 