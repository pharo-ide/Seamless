*Seamless
handleSeamlessRequest: anEvaluationRequest receivedFrom: senderPeer
	| seamlessResult |
	seamlessResult := SeamlessNonLocalReturnResult with: result homeContext: home.
	
	anEvaluationRequest returnResult: seamlessResult to: senderPeer