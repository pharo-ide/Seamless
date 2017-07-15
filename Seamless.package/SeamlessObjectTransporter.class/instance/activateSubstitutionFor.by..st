sending-private
activateSubstitutionFor: anObject by: aBlock

	| substitution |
	substitution := objectSubstitutions removeKey: anObject ifAbsent: [ ^self ].
	aBlock value: substitution