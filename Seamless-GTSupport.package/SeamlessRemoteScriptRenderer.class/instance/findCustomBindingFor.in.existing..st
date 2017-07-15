private
findCustomBindingFor: aString in: anObject existing: currentBindings

	(anObject seamlessIsBindingVisible: aString) ifTrue: [ ^nil ].

	(currentBindings includesKey: aString) ifFalse: [ 
		currentBindings add: (SeamlessRemoteWorkspaceVariable key: aString asSymbol) ].
	
	^currentBindings associationAt: aString