accessing
readRemoteValue
	"It is possible that remote request will be delivered to remote side but response will hangs.
	We should setup timeout in that case and ignore possible value update"
	
	[
		[value := remoteVariable read] ifError: [  ]
	] valueWithin: 2 seconds onTimeout: [].
	
	^value