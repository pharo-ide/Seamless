operations
loadDeepCopy: aSeamlessProxy

	| context |
	context := senderPeer createSyncRequestContext.
	
	^context sendRequest: (SeamlessLoadDeepCopyRequest proxy: aSeamlessProxy)