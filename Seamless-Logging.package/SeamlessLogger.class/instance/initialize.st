initialization
initialize
	super initialize.
	isRunning := false.
	requests := OrderedCollection new: 2000.
	outgoingLink := MetaLink new 
		metaObject: self; 
		selector: #interceptOutgoingRequest:;
		arguments: #(arguments).
	incomingLink := MetaLink new 
		metaObject: self; 
		selector: #logIncomingRequest:;
		arguments: #(receiver)