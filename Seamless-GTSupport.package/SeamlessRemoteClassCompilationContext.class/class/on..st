instance creation
on: remoteClass
	| context |
	context := self new 
		class: remoteClass;		
		yourself.
	(OpalCompiler respondsTo: #defaultOptions) ifTrue: [
		"Compatibility with Pharo 6" 
		context parseOptions: OpalCompiler defaultOptions].
	^context