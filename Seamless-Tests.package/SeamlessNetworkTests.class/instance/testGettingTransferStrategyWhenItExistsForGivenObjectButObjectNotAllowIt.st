tests
testGettingTransferStrategyWhenItExistsForGivenObjectButObjectNotAllowIt

	| actual |
	[:strategy :object |
		network addTransferStrategy: strategy.
		(strategy stub isAppliedTo: object) willReturn: true.
		object stub isOnlyDefaultTransferStrategyAllowed willReturn: true.
		
		actual := network transferStrategyFor: object.
		
		actual should beReturnedFrom: [ object seamlessDefaultTransferStrategy ]
	] runWithMocks 