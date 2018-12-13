operations
sendRequest: aSeamlessRequest 

	aSeamlessRequest context: self.
	
	self forkProcessingOf: aSeamlessRequest.

	resultWaiter waitTimeoutSeconds: 3.
	
	"Here we fix data statistics about request execution"
	aSeamlessRequest resultBytes: result transferredBytes.
	
	^result returnValue