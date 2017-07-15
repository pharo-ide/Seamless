tests
testOutgoingRequestCheck

	(context stub isKindOf: SeamlessRequestSendingContext) willReturn: true.
	
	request should be isOutgoing.
	
	(context stub isKindOf: SeamlessRequestSendingContext) willReturn: false.
	
	request should not be isOutgoing.