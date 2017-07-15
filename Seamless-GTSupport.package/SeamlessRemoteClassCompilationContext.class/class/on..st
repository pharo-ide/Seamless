instance creation
on: remoteClass
	^self new 
		parseOptions: OpalCompiler defaultOptions;
		class: remoteClass;
		yourself