operations
sendDataPacket: aSeamlessRequest by: aBasysConnection

	| transporter |
	transporter := transport newTransporterFor: self toTransferBy: aBasysConnection remotePeer.
	
	transporter sendObject: aSeamlessRequest by: aBasysConnection