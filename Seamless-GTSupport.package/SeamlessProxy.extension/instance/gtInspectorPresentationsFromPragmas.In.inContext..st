*Seamless-GTSupport
gtInspectorPresentationsFromPragmas: aCollection In: composite inContext: aGTInspector

	aCollection
		do: [ :eachPragma | 
			eachPragma methodSelector numArgs = 1
				ifTrue: [ 
					GHMetaMessages  
						withReceiver: self 
						perform: eachPragma methodSelector 
						withArguments: { composite } 
						inClass: self class ].
			eachPragma methodSelector numArgs = 2
				ifTrue: [ 
					GHMetaMessages  
						withReceiver: self 
						perform: eachPragma methodSelector 
						withArguments: { composite . aGTInspector } 
						inClass: self class ] ]