instance creation
for: aBasysConnection

	^(self receiverPeer: aBasysConnection remotePeer)
		connection: aBasysConnection