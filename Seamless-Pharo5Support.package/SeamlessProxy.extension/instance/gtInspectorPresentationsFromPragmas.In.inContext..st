*Seamless-Pharo5Support
gtInspectorPresentationsFromPragmas: aCollection In: composite inContext: aGTInspector

	aCollection
		do: [ :eachPragma | 
			eachPragma selector numArgs = 1
				ifTrue: [ 
					GHMetaMessages  
						withReceiver: self 
						perform: eachPragma selector 
						withArguments: { composite } 
						inClass: self class ].
			eachPragma selector numArgs = 2
				ifTrue: [ 
					GHMetaMessages  
						withReceiver: self 
						perform: eachPragma selector 
						withArguments: { composite . aGTInspector } 
						inClass: self class ] ]