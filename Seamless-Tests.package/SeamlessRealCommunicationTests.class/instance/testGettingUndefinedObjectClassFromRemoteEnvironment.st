tests
testGettingUndefinedObjectClassFromRemoteEnvironment
 
			
	| remoteEnv remoteClass |
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #UndefinedObject].

	remoteClass should beInstanceOf: SeamlessProxy