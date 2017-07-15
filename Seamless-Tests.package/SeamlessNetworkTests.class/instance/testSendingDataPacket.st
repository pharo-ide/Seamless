tests
testSendingDataPacket
	
	[:transporterClass :transporter :connection |
		network transport: transporterClass.
		connection stub remotePeer willReturn: #receiverPeer.
		(transporterClass stub newTransporterFor: network toTransferBy:  #receiverPeer) 
			willReturn: transporter.
		
		network sendDataPacket: #dataPacket by: connection.
		 
		transporter should receive sendObject: #dataPacket by: connection
	] runWithMocks 