tests
testAddingDefaultTransferStrategyWithPriority

	| actual |
	network transferByDefaultStrategy: #criteria priority: 200.
	
	actual := network transferStrategies anyOne.
	
	actual should beInstanceOf: SeamlessDefaultTransferStrategy.
	actual where criteria should be: #criteria.
	actual where priority should be: 200