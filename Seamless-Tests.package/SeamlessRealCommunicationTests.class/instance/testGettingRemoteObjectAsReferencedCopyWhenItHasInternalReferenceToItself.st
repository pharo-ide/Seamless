tests
testGettingRemoteObjectAsReferencedCopyWhenItHasInternalReferenceToItself
 
	| remoteEnv remoteArray serverSideArray remoteClass child original returnedOriginal serverSideCopy |
	clientSideNetwork transferByValue:  (Instance of: SeamlessTestContainer2).
	clientSideNetwork transferByReferencedCopy:  (Instance of: SeamlessTestContainer).
	child := SeamlessTestContainer2 named: 'child' with: nil.
	original := SeamlessTestContainer named: 'root' with: child.
	child content: original.
		
	self forkAndWait: [
		remoteEnv := clientSideNetwork environmentAt: self serverAddress.
		remoteClass := remoteEnv at: #Array.		
		remoteArray := remoteClass with: original.		
		returnedOriginal := remoteArray first].

	returnedOriginal should be: original.
	returnedOriginal name should equal: 'root'.
	returnedOriginal content should beInstanceOf: SeamlessTestContainer2.
	returnedOriginal content name should equal: 'child'.
	returnedOriginal content content should be: returnedOriginal.
	serverSideArray := serverSideNetwork objectFor: remoteArray seamlessReference.
	serverSideCopy := serverSideArray first.
	serverSideCopy should not beInstanceOf: SeamlessProxy.
	serverSideCopy should not be: original.
	serverSideCopy name should equal: 'root'.
	serverSideCopy content should beInstanceOf: SeamlessTestContainer2.
	serverSideCopy content name should equal: 'child'.
	serverSideCopy content content should be: serverSideCopy