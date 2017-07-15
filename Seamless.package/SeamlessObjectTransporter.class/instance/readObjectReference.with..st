serialize/materialize
readObjectReference: anObjectReference with: aTostMaterialization
	| type uuid |
	type := aTostMaterialization readByte.
	anObjectReference id: aTostMaterialization readPositiveInteger.
	anObjectReference senderPeer: remotePeer.	
	type = 0 ifTrue: [ "it is reference to my local object"
		^anObjectReference ownerPeerId: network localPeerId].
	type = 1 ifTrue: [ "it is reference owned by sender remote peer"
		remotePeer id ifNil: [self error: 'it should not happen: we receive reference with type 1 from sender which is not identifyed yet'].
		 ^anObjectReference ownerPeerId: remotePeer id].
	
	uuid := aTostMaterialization readBytes: 16 as: UUID.
	anObjectReference ownerPeerId: uuid