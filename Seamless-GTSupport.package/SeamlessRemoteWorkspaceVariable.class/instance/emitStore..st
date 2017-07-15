code generation
emitStore: methodBuilder

	| tempName |
	tempName := Object new.
	methodBuilder
		addTemp: tempName;
		storeTemp: tempName;
		popTop;
		pushLiteralVariable: #slot -> self;
		pushTemp: tempName;
		send: #write: