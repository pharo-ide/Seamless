accessing
read

	remoteVariable remotePeer isConnected ifFalse: [ ^value].
	
	self isUnassigned ifTrue: [ 
		self value: remoteVariable read.
		^value].

	[value := remoteVariable read] ifError: [  ].
	^value