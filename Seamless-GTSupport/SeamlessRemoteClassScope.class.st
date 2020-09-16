Class {
	#name : #SeamlessRemoteClassScope,
	#superclass : #OCClassScope,
	#category : #'Seamless-GTSupport'
}

{ #category : #lookup }
SeamlessRemoteClassScope >> lookupVar: name [
	"Return a SemVar for my pool var with this name.  Return nil if none found"
	| ocClass |
	^(class bindingOf: name asSymbol) ifNotNil: [:assoc | 
		"Compatibility with Pharo 9 where all variables were unified under single Variable hierarchy"
		(self class environment hasClassNamed: #OCLiteralVariable) ifFalse: [ ^assoc ].
		ocClass := self class environment classNamed: #OCLiteralVariable.
		ocClass isDeprecated ifTrue: [ ^ assoc ].
		ocClass new 
			assoc: assoc; 
			scope: self; 
			yourself]

]
