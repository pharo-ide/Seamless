*Seamless-Tests
testEvaluationBlockRemotelly

	| localBlock |
	[:context :block |
		localBlock := [ #localBlock ].
		peer stub createSyncRequestContext willReturn: context.
		block stub asLocalObject willReturn: localBlock.
		(context stub sendRequest: Arg request) willReturn: #result.
		
		(peer evaluate: block) should be: #result.
		Arg request should beInstanceOf: SeamlessBlockEvaluationRequest.
		Arg request valuable should be: localBlock
	] runWithMocks 
	