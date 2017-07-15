instance creation
on: remoteClass requestor: aRequestor
	^self new 
		parseOptions: OpalCompiler defaultOptions;
		requestor: aRequestor;
		class: remoteClass;		
		yourself