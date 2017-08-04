accessing
read

	remoteVariable remotePeer isConnected ifFalse: [ ^value].
	
	self isUnassigned ifTrue: [ ^value := remoteVariable read].

	[value := remoteVariable read] ifError: [  ].
	^value