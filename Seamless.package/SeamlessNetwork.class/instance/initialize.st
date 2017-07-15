initialization
initialize
	super initialize.
	
	distributedObjects := SeamlessDistributedObjects over: self.
	transferStrategies := SortedCollection sortBlock: [:a :b | a priority >= b priority].
	transport := SeamlessObjectTransporter default.
	connectionTimeout := 10 seconds.