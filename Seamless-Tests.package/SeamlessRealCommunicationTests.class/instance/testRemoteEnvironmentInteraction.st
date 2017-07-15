tests
testRemoteEnvironmentInteraction
 
	| result remoteClass remoteCollection remoteEnv |
			
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #OrderedCollection.
		remoteCollection := remoteClass new: 10 withAll: #testValue.
		result := remoteCollection at: 3 ifAbsent: [  ]  ].

	result should be: #testValue