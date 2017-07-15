tests
testAddingTransferStrategyByReferenceWithSmartMessage

	| actual |
	network transferByReference: #criteria.
	
	actual := network transferStrategies anyOne.
	
	actual should beInstanceOf: SeamlessTransferByReferenceStrategy.
	actual where criteria should be: #criteria