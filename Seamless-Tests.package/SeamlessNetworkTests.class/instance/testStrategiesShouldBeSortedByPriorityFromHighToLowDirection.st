tests
testStrategiesShouldBeSortedByPriorityFromHighToLowDirection

	| actual strategy1 strategy2 |
	strategy1 := SeamlessTransferByValueStrategy new.
	network addTransferStrategy: strategy1 priority: 10.

	strategy2 := SeamlessTransferByValueStrategy new.
	network addTransferStrategy: strategy2 priority: 100.
	
	actual := network transferStrategies.
	
	actual first should be: strategy2.
	actual last should be: strategy1