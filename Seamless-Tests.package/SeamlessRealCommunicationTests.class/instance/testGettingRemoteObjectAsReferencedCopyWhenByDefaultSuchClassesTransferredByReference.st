tests
testGettingRemoteObjectAsReferencedCopyWhenByDefaultSuchClassesTransferredByReference
 
	| remoteEnv point remoteArray returnedOriginalPoint serverSideArray remoteClass |
	point := 2@3.
	clientSideNetwork transferByReferencedCopy: (Identical to: point).
	clientSideNetwork transferByReference: (Kind of: Point).
	serverSideNetwork transferByReference: (Kind of: Point).
		
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Array.
		remoteArray := remoteClass with: point.
		returnedOriginalPoint := remoteArray first].

	returnedOriginalPoint should be: point.
	serverSideArray := serverSideNetwork objectFor: remoteArray seamlessReference.
	serverSideArray first should not beInstanceOf: SeamlessProxy.
	serverSideArray first should equal: point.
	serverSideArray first should not be: point