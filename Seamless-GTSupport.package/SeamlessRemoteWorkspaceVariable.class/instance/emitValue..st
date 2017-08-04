code generation
emitValue: methodBuilder

	methodBuilder 
		pushLiteralVariable: #slot -> state;
		send: #read