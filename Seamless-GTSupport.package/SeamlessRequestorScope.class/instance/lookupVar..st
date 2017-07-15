lookup
lookupVar: name
	name = 'self' ifTrue: [  ^outerScope lookupVar: name].
	name = 'super' ifTrue: [  ^outerScope lookupVar: name]. 
	name first isUppercase ifTrue: [ ^outerScope lookupVar: name ].  
	((compilationContext forSyntaxHighlighting) and: [(requestor hasBindingOf: name asSymbol) not]) 
		ifTrue: [  ^ super lookupVar: name].
	^ (super lookupVar: name) ifNil: [ (requestor bindingOf: name asSymbol) 
		ifNotNil: [:assoc | ^ OCLiteralVariable new assoc: assoc; scope: self; yourself].
	]. 