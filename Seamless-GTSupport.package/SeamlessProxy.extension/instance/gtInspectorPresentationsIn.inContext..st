*Seamless-GTSupport
gtInspectorPresentationsIn: composite inContext: aGTInspector
	"This is a utility method that collects all presentations for the current object.
	By default, it simply looks for the #gtInspectorPresentationOrder: pragma.
	The inspector can decice whether or not a presentation should be dispayed.
	Subclasses might want to override it for more special behavior."
	| pragmas |
	pragmas := Pragma
		allNamed: #gtInspectorPresentationOrder:
		from: self ghostClass
		to: GHObjectGhost
		sortedUsing: [ :x :y | (x argumentAt: 1) < (y argumentAt: 1) ].
	pragmas := pragmas select: [ :aPragma | 
		(aGTInspector respondsTo: #shouldDisplayPresentationCreatedBy:)
			ifTrue: [ "Pharo6" aGTInspector shouldDisplayPresentationCreatedBy: aPragma method]
			ifFalse: [ "Pharo5" aGTInspector shouldDisplayPresentationCreateBy: aPragma method ] ].
	self gtInspectorPresentationsFromPragmas: pragmas In: composite inContext: aGTInspector