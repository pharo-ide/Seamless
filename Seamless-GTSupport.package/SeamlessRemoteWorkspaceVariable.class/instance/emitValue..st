code generation
emitValue: methodBuilder

	methodBuilder 
		pushLiteralVariable: #slot -> self;
		send: #read