tests
testReturningResult
	
	[:network :waiterSemaphore |
		context resultWaiter: waiterSemaphore.
		waiterSemaphore signal when: [ context result ] is: #result.
		
		context return: #result.

		waiterSemaphore should receive signal
	
	 ] runWithMocks 