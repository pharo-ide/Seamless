accessing
at: aSeamlessObjectReference ifPresent: presentBlock ifAbsentUseProxy: proxyBlock
	| object |
	object := lock criticalRead: [ referencesToObjects at: aSeamlessObjectReference ifAbsent: [ nil ] ].
	
	(object isNil and: [aSeamlessObjectReference ownerPeerId = network localPeerId])
		ifTrue: [ object := SeamlessMissingObject referencedBy: aSeamlessObjectReference ].
				
	object 
		ifNotNil: presentBlock
		ifNil: [ 	lock criticalWrite: [ 
			object := proxyBlock value.
			objectsToReferences at: object put: aSeamlessObjectReference.
			referencesToObjects at: aSeamlessObjectReference put: object ]
	].

	^object