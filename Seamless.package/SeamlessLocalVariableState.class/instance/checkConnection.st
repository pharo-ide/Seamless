testing
checkConnection
	remoteVariable ifNil: [ ^false].
	
	remoteVariable remotePeer isConnected ifTrue: [ ^true ].
	remoteVariable := nil.
	^false