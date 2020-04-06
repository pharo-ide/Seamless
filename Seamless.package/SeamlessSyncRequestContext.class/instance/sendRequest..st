operations
sendRequest: aSeamlessRequest 
	
	aSeamlessRequest context: self.
	
	self forkProcessingOf: aSeamlessRequest.
	
	WaitTimeout > 0 
	ifTrue: [ resultWaiter waitTimeoutSeconds: WaitTimeout]
	ifFalse: [ resultWaiter wait ].

	"Here we fix data statistics about request execution"
	aSeamlessRequest resultBytes: result transferredBytes.
	
	^result returnValue