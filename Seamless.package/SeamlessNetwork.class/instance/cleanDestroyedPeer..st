controlling
cleanDestroyedPeer: aRemotePeer

	aRemotePeer close.
	distributedObjects removeObjectsDistributedBy: aRemotePeer.
	remotePeers remove: aRemotePeer ifAbsent: [].
	remotePeers ifEmpty: [ distributedObjects clear ]