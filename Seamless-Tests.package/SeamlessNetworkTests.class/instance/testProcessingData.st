tests
testProcessingData

	[ :request |
		[ network process: request receivedFrom: #remotePeer]
			should strictly satisfy: 
		[ request executeFor: #remotePeer ]
	 ] runWithMocks 