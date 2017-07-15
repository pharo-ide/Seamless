tests
testCreationIdentificationContext

	| context |
	context := connection createIdentificationContext.

	context should beInstanceOf: SeamlessPeerIdentificationContext.
	context connection should be: connection.
	context receiverPeer should be: remotePeer