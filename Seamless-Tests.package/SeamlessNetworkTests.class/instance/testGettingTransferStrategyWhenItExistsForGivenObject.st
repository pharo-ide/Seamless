tests
testGettingTransferStrategyWhenItExistsForGivenObject

	[:strategy1 :strategy2 |
		network addTransferStrategy: strategy1; addTransferStrategy: strategy2.
		
		(strategy1 stub isAppliedTo: #object) willReturn: false.
		(strategy2 stub isAppliedTo: #object) willReturn: true.
		
		(network transferStrategyFor: #object) should be: strategy2
	] runWithMocks 