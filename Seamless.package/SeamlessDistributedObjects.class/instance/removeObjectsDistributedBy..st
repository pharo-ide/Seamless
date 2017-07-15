accessing
removeObjectsDistributedBy: aRemotePeer
	
	| references |
	lock criticalRead: [ 
		references := objectsToReferences select: [ :each |
			each senderPeer == aRemotePeer ]].
	lock criticalWrite: [ 
		references do: [ :each | | object |
			object := referencesToObjects removeKey: each.
			objectsToReferences removeKey: object]
	]