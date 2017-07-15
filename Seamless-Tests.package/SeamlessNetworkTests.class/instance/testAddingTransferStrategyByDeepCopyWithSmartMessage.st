tests
testAddingTransferStrategyByDeepCopyWithSmartMessage

	| actual |
	network transferByDeepCopy: #criteria.
	
	actual := network transferStrategies anyOne.
	
	actual should beInstanceOf: SeamlessTransferByDeepCopyStrategy.
	actual where criteria should be: #criteria