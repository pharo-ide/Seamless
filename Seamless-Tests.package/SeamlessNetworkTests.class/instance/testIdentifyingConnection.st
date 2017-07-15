tests
testIdentifyingConnection

	| sentRequest |
	[:connection :context |		
		network localPeer id: #localPeerId.
		[ (network identifyLocalPeerOn: connection) should be: #remotePeerId ]
			should strictly satisfy: 
		[connection createIdentificationContext willReturn: context.
		(context sendRequest: Any) will: [ :arg | sentRequest := arg. #remotePeerId ] ].
	
		sentRequest should beInstanceOf: SeamlessPeerIdentificationRequest.
		sentRequest peerId should be: #localPeerId
	 ] runWithMocks 