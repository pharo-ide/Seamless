converting
handleSeamlessRequest: anEvaluationRequest receivedFrom: senderPeer
	| result |
	result := SeamlessThrowExceptionResult with: self.
	
	anEvaluationRequest returnResult: result to: senderPeer