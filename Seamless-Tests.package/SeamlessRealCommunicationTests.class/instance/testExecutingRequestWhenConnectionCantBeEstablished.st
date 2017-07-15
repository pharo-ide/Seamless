tests
testExecutingRequestWhenConnectionCantBeEstablished
	
	server stop.
	
	self forkAndWait: [
		[clientSideNetwork environmentAt: self serverAddress] should raise: ConnectionTimedOut
	]