tests
testRemoteMessageWithExplicitArgumentByDeepCopy
 	
	| remoteEnv remoteArray createdArray remoteClass |
	clientSideNetwork transferByReference: (Kind of: Point).
	clientSideNetwork transferByReference: (Instance of: Array).
	
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Array.
		remoteArray := remoteClass with: {10@30} asTransferredByDeepCopy
	].
	
	createdArray := serverSideNetwork objectFor: remoteArray seamlessReference.
	createdArray first should beInstanceOf: Array.
	createdArray first first should beInstanceOf: Point.
	createdArray should equal: { {10@30} }