operations
receiveIncomingDataPacketFrom: aRemotePeer by: aBasysConnection

	| transporter |
	transporter := transport newTransporterFor: self toTransferBy: aRemotePeer.
	
	^transporter receiveObjectBy: aBasysConnection