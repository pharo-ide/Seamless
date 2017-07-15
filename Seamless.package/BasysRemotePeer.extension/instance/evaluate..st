*Seamless
evaluate: aBlock

	^self createSyncRequestContext sendRequest: (SeamlessBlockEvaluationRequest with: aBlock asLocalObject)