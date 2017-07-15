running
setUp
	| transferBuffer |
	super setUp.
	
	network := SeamlessNetwork new.
	transporter := SeamlessObjectTransporter default 
		newTransporterFor: network toTransferBy: (BasysActiveRemotePeer new id: UUID new).
	
	connection := Mock new.
	transferBuffer := ByteArray new: 10000.
	connection stub inputStream will: [ transferBuffer readStream].
	connection stub outputStream will: [ transferBuffer writeStream].