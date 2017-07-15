private
createNewReferenceFor: anObject by: refCreationBlock
	"it should be called inside lock critical section"
	
	| reference |
	anObject isSeamlessProxy ifTrue: [ 
		"it is case when alien proxy (form another network on this image) is transfered inside this current network (which is not connected to proxy one)"
		^anObject seamlessReference ].
	
	reference := refCreationBlock value.
	
	reference 
		id: (lastReferenceId := lastReferenceId + 1);
		ownerPeerId: network localPeerId;
		senderPeer: network localPeer.
		
	^reference