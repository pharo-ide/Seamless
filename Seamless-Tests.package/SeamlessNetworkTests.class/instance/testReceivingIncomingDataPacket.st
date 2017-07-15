tests
testReceivingIncomingDataPacket

	| result |
	[:transport :transporter |
		network transport: transport.
		(transport stub newTransporterFor: network toTransferBy: #remotePeer) willReturn: transporter.
		
		result := network receiveIncomingDataPacketFrom: #remotePeer by: #connection.
		
		result should beReturnedFrom: [transporter receiveObjectBy: #connection]		
	] runWithMocks 