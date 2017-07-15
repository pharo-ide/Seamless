default
collectWellKnownClasses

	| wellKnownClasses |
	wellKnownClasses := (SortedCollection new: 255) sortBlock: [:a :b | a name < b name].
	Object allSubclassesDo: [:each |
		each isWellKnownSeamlessClass ifTrue: [ wellKnownClasses add: each ]].

	^wellKnownClasses asArray