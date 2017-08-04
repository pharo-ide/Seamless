code generation
emitStore: methodBuilder

	| tempName |
	tempName := Object new.
	methodBuilder
		addTemp: tempName;
		storeTemp: tempName;
		popTop;
		pushLiteralVariable: #slot -> state;
		pushTemp: tempName;
		send: #write: