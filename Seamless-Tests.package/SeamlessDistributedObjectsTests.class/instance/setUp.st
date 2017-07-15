running
setUp
	super setUp.
	
	network := SeamlessNetwork new.
	distributedObjects := SeamlessDistributedObjects over: network