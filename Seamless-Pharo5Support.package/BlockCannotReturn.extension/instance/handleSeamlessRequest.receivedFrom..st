*Seamless-Pharo5Support
handleSeamlessRequest: anEvaluationRequest receivedFrom: senderPeer
	| seamlessResult |
	seamlessResult := SeamlessNonLocalReturnResult with: result homeContext: deadHome.
	
	anEvaluationRequest returnResult: seamlessResult to: senderPeer