operations
return: aSeamlessRequestResult to: senderPeer
	
	senderPeer sendDataPacket: (SeamlessDeliverResultRequest result: aSeamlessRequestResult to: self).
	
	senderPeer network removeDistributedObject: self