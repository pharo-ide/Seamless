tests
testAddingDefaultTransferStrategyWithSmartMessage

	| actual |
	network transferByDefaultStrategy: #criteria.
	
	actual := network transferStrategies anyOne.
	
	actual should beInstanceOf: SeamlessDefaultTransferStrategy.
	actual where criteria should be: #criteria