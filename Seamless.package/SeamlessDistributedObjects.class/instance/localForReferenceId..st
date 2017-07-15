accessing
localForReferenceId: id 
	| reference |
	reference := objectsToReferences keysAndValuesDo: [ :o :ref | 
		(ref id = id and: [ ref senderPeer class = BasysLocalPeer ])
			ifTrue: [ ^o ]].
	
	KeyNotFound signalFor: id in: self 