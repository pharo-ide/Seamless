tests
testGettingRemoteObjectAsReferencedCopyWhenNextReferenceIsValue
 
	| remoteEnv point remoteArray remoteClass returnedOriginalArray |
	serverSideNetwork transferByValue: (Instance of: Array).	
	clientSideNetwork transferByValue: (Instance of: Array).
	clientSideNetwork transferByReferencedCopy: (Instance of: Point).
	point := 2@3.	
	self forkAndWait: [.
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Array.
		remoteArray := remoteClass with: {point. #secondValue}.		
		returnedOriginalArray := remoteArray first].

	returnedOriginalArray should beInstanceOf: Array.
	returnedOriginalArray first should be: point.
	returnedOriginalArray last should be: #secondValue