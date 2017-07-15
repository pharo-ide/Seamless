tests
testGettingTrueClassFromRemoteEnvironment
 
			
	| remoteEnv remoteClass |
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #True].

	remoteClass should beInstanceOf: SeamlessProxy