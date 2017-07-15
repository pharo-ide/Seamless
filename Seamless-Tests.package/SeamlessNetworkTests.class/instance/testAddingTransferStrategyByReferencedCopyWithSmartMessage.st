tests
testAddingTransferStrategyByReferencedCopyWithSmartMessage

	| actual |
	network transferByReferencedCopy: #criteria.
	
	actual := network transferStrategies anyOne.
	
	actual should beInstanceOf: SeamlessTransferByReferencedCopyStrategy.
	actual where criteria should be: #criteria