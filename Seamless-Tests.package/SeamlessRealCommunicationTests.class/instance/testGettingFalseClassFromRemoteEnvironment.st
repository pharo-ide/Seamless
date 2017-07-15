tests
testGettingFalseClassFromRemoteEnvironment
 
			
	| remoteEnv remoteClass |
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #False].

	remoteClass should beInstanceOf: SeamlessProxy