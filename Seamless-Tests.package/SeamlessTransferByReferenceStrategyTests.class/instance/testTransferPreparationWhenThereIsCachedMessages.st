tests
testTransferPreparationWhenThereIsCachedMessages

	| transferObject |
	strategy cachedMessages: #(#x #y).
	
	transferObject := strategy prepareTransferObjectFor: 10@20 by: transporter.
		
	transferObject should receive cacheMessage: #x with: 10.
	transferObject should receive cacheMessage: #y with: 20.