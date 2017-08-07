accessing
read

	self checkConnection ifFalse: [ ^value].
	
	self isUnassigned ifTrue: [ 
		self value: remoteVariable read.
		^value].

	^self readRemoteValue