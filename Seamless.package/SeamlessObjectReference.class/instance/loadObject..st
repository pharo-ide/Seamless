operations
loadObject: aSeamlessProxy

	| context |
	context := senderPeer createSyncRequestContext.
	
	^context sendRequest: (SeamlessLoadObjectRequest proxy: aSeamlessProxy)