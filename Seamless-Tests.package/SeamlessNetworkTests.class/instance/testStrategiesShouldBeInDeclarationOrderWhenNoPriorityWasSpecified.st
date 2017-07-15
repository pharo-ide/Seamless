tests
testStrategiesShouldBeInDeclarationOrderWhenNoPriorityWasSpecified

	| actual strategy1 strategy2 |
	strategy1 := SeamlessTransferByValueStrategy new.
	network addTransferStrategy: strategy1.

	strategy2 := SeamlessTransferByValueStrategy new.
	network addTransferStrategy: strategy2.
	
	actual := network transferStrategies.
	
	actual first should be: strategy1.
	actual last should be: strategy2