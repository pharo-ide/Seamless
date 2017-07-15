tests
testGettingRemoteObjectAsReferencedCopyWhenItIncludesOtherReferences
 
	| remoteEnv point remoteContainer serverSideContainer remoteClass array returnedOriginalArray serverSideArray |
	
	point := 2@3.
	array := { point }.
	clientSideNetwork transferByReferencedCopy: (Identical to: array).
	clientSideNetwork transferByReference: (Instance of: Point).
	serverSideNetwork transferByReference: (Instance of: Point).	
		
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Array.
		remoteContainer := remoteClass with: array.
		returnedOriginalArray := remoteContainer first].

	returnedOriginalArray should be: array.
	returnedOriginalArray first should be: point.
	serverSideContainer := serverSideNetwork objectFor: remoteContainer seamlessReference.
	serverSideArray := serverSideContainer first.
	serverSideArray should not beInstanceOf: SeamlessProxy.
	serverSideArray first should beInstanceOf: SeamlessProxy.
	
