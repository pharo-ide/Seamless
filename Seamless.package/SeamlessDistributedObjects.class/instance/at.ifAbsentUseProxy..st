accessing
at: aSeamlessObjectReference ifAbsentUseProxy: proxyBlock
	| object |
	object := lock criticalRead: [ referencesToObjects at: aSeamlessObjectReference ifAbsent: [ nil ] ].
	object ifNil: [ 
		aSeamlessObjectReference ownerPeerId = network localPeerId 
				ifTrue: [ ^SeamlessMissingObject referencedBy: aSeamlessObjectReference ].
				
		lock criticalWrite: [ 
			object := proxyBlock value.
			objectsToReferences at: object put: aSeamlessObjectReference.
			referencesToObjects at: aSeamlessObjectReference put: object ]
	].

	^object