operations
sendRequest: aSeamlessRequest 

	aSeamlessRequest context: self.
	
	self forkProcessingOf: aSeamlessRequest.

	resultWaiter wait.
	
	"Here we fix data statistics about request execution"
	aSeamlessRequest resultBytes: result transferredBytes.
	
	^result returnValue