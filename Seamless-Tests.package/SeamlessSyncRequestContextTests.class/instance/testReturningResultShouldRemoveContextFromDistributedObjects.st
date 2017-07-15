tests
testReturningResultShouldRemoveContextFromDistributedObjects
	
	[:network |
		receiverPeer stub network willReturn: network.
		
		context return: #result.
		
		network should receive removeDistributedObject: context.
			
	 ] runWithMocks 