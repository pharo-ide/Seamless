tests
testGettingRemoteObjectAsReferencedCopy
 
	| remoteEnv point remoteArray returnedOriginalPoint serverSideArray remoteClass |
	
	clientSideNetwork transferByReferencedCopy:  (Instance of: Point).
	point := 2@3.	
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Array.		
		remoteArray := remoteClass with: point.		
		returnedOriginalPoint := remoteArray first].

	returnedOriginalPoint should be: point.
	returnedOriginalPoint should equal: 2@3.
	serverSideArray := serverSideNetwork objectFor: remoteArray seamlessReference.
	serverSideArray first should not beInstanceOf: SeamlessProxy.
	serverSideArray first should equal: point.
	serverSideArray first should not be: point