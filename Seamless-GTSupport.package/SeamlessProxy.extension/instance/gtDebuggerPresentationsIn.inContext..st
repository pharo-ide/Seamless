*Seamless-GTSupport
gtDebuggerPresentationsIn: composite inContext: aGTInspector
	| pragmas |
	pragmas := (Pragma 
				allNamed: #gtDebuggerPresentationOrder:
				from: self ghostClass 
				to: GHObjectGhost) asOrderedCollection.
	pragmas := pragmas sorted: [: x :y | (x argumentAt: 1) < (y argumentAt: 1)].
	self gtInspectorPresentationsFromPragmas: pragmas In: composite inContext: aGTInspector
