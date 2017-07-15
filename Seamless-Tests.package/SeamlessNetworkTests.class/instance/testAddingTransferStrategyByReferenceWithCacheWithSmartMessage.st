tests
testAddingTransferStrategyByReferenceWithCacheWithSmartMessage

	| actual |
	network transferByReference: #criteria withCacheFor: #messageSelectors.
	
	actual := network transferStrategies anyOne.
	
	actual should beInstanceOf: SeamlessTransferByReferenceStrategy.
	actual where criteria should be: #criteria.
	actual where cachedMessages should be: #messageSelectors