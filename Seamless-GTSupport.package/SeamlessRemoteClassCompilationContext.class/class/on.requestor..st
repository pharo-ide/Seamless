instance creation
on: remoteClass requestor: aRequestor

	| compilerContext |
	compilerContext := self new.
	(OpalCompiler respondsTo: #defaultOptions) "Support for Pharo 6"
		ifTrue: [  compilerContext parseOptions: OpalCompiler defaultOptions].
	^compilerContext
		requestor: aRequestor;
		class: remoteClass;		
		yourself