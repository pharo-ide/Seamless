Extension { #name : #BasysPassiveRemotePeer }

{ #category : #'*Seamless' }
BasysPassiveRemotePeer >> destroy [
	"Because passive peer can't establish new connections we can not wait timeout in case when no connections are available. For details look at superclass"
	
	self isConnected ifFalse: [ 
		network cleanDestroyedPeer: self.
		^self ].
		
	super destroy
]
