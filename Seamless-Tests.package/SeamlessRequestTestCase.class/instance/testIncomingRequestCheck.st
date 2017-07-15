tests
testIncomingRequestCheck

	(context stub isKindOf: SeamlessRequestSendingContext) willReturn: true.
	
	request should not be isIncoming.
	
	(context stub isKindOf: SeamlessRequestSendingContext) willReturn: false.
	
	request should be isIncoming.