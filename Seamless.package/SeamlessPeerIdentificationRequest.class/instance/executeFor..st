execution
executeFor: senderPeer
	
	| identifiedPeer |
	identifiedPeer := senderPeer beIdentifiedAs: peerId.
	
	context returnValue: senderPeer localPeerId to: identifiedPeer