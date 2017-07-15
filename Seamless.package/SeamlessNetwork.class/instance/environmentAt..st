requests
environmentAt: anAddress 

	| remotePeer |
	remotePeer := self remotePeerAt: anAddress.
	^remotePeer remoteEnvironment