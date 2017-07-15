tests
testShouldAllowOnlyDefaultTransferStrategy
	
	| container |
	container := SeamlessObjectValueContainer with: Any.
		
	container should be isOnlyDefaultTransferStrategyAllowed 