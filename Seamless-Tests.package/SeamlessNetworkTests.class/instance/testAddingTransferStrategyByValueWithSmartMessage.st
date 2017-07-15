tests
testAddingTransferStrategyByValueWithSmartMessage

	| actual |
	network transferByValue: #criteria.
	
	actual := network transferStrategies anyOne.
	
	actual should beInstanceOf: SeamlessTransferByValueStrategy.
	actual where criteria should be: #criteria