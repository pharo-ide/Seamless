Class {
	#name : #SeamlessRemoteClassScope,
	#superclass : #OCClassScope,
	#category : 'Seamless-GTSupport'
}

{ #category : #lookup }
SeamlessRemoteClassScope >> lookupVar: name [
	"Return a SemVar for my pool var with this name.  Return nil if none found"
	^(class bindingOf: name asSymbol) ifNotNil: [:assoc | 
		OCLiteralVariable new 
			assoc: assoc; 
			scope: self; 
			yourself]

]
