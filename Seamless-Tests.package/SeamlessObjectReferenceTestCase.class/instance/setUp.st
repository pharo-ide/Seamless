running
setUp
	super setUp.
	
	peer := Mock new.
	peer stub id willReturn: #peerId.
	
	reference := self referenceClass id: #referenceId peer: peer