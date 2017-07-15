operations
identifyLocalPeerOn: aConnection

	| context |
	context := aConnection createIdentificationContext.

	^context sendRequest: (SeamlessPeerIdentificationRequest peerId: self localPeerId).
	