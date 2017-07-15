tests
testRemoteMessageWithExplicitArgumentByValue
 	
	| remoteEnv remoteArray localArray |
	clientSideNetwork transferByReference: (Kind of: Point).
	
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteArray := (remoteEnv at: #Array) with: (10@30) asTransferredByValue.
		localArray := remoteArray asLocalObject].

	localArray first should beInstanceOf: SeamlessProxy