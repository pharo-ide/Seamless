*Seamless
isWellKnownSeamlessClass
	"Classes which define method #definesWellKnownSeamlessClass as true will be collected as well known classes for seamless transfer. Well known classes is optimization for seamless communication protocol to reduce size of transferred packets.
	If class only inherits method #definesWellKnownSeamlessClass (from superclasses) then it will not be well known. To force full hierarchy of classes be well known method #isWellKnownSeamlessClassHierarchy should be implemented with true by superclass"
	
	self definesWellKnownSeamlessClass ifFalse: [ ^false ].
	
	^self definesWellKnownSeamlessClassHierarchy 
		or: [self class includesSelector: #definesWellKnownSeamlessClass]