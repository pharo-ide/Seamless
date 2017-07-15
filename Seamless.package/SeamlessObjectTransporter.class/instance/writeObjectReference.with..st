serialize/materialize
writeObjectReference: anObjectReference with: aTostSerialization
	| type |
	type := 2 "given reference is alien. It is not belongs to sender or receiver peers".
	
	aTostSerialization isTransferIdentificationRequest ifFalse: [
		anObjectReference ownerPeerId = remotePeer id 
			ifTrue: [ type := 0 ] "reference belongs to receiver"
			ifFalse: [ anObjectReference ownerPeerId = network localPeerId 
							ifTrue: [ type := 1 ]] "reference from this local peer" .
	].
	aTostSerialization writeByte: type.
	aTostSerialization writePositiveInteger: anObjectReference id.
	
	type = 2 ifTrue: [ aTostSerialization writeBytes: anObjectReference ownerPeerId]