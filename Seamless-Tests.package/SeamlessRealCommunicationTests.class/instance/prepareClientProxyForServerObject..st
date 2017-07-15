helpers
prepareClientProxyForServerObject: serverSideObject

	| serverSideReference clientSideReference |
	serverSideNetwork transferByReference: (Identical to: serverSideObject).
	
	serverSideReference := serverSideNetwork referenceFor: serverSideObject.
	clientSideReference := serverSideReference copy.
	clientSideReference senderPeer: (clientSideNetwork remotePeerAt: self serverAddress).
	
	^clientSideNetwork objectFor: clientSideReference