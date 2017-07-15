initialization
initialize
	super initialize.
	
	resultWaiter := Semaphore new.
	senderProcess := Processor activeProcess