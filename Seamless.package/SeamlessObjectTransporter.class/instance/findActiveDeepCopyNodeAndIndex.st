sending-deep copy
findActiveDeepCopyNodeAndIndex
	
	objectsByDeepCopy associationsDo: [ :objectAndIndex |
		objectAndIndex value > 0 ifTrue: [ ^objectAndIndex  ]].
	
	^nil