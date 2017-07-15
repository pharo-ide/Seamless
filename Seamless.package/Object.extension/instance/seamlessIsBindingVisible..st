*Seamless
seamlessIsBindingVisible: aString
	"this methods is suitable for tools to detect if some binding visible by remote object.
	For example inspector evaluators could use it to distinguish local workspace variable 
	from normal accessible objects"
	
	(self class allInstVarNames includes: aString) ifTrue: [ ^true ].
	
	^(self class bindingOf: aString) notNil