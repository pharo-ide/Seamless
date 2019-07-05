Extension { #name : #SeamlessProxy }

{ #category : #'*Seamless-GTSupport' }
SeamlessProxy class >> compilerClass [

	^SeamlessRemoteClassCompiler
]

{ #category : #'*Seamless-GTSupport' }
SeamlessProxy >> findGlobalVariable: lookupBlock ifNone: notFoundBlock [
	^notFoundBlock value
]

{ #category : #'*Seamless-GTSupport' }
SeamlessProxy >> findVariable: lookupBlock ifNone: notFoundBlock [
	^notFoundBlock value
]

{ #category : #'*Seamless-GTSupport' }
SeamlessProxy >> gtConstructDebuggerInspectorIn: composite for: aDebugger [
	
	^composite custom: ((GTDebuggerInspector new  
		debugger: aDebugger;
		notifyPaneRemoved: true;
		showFirst: [ :a | a custom: (SeamlessDebuggerVariablesBrowser new 
			debugger: aDebugger;
			title: 'Variables';
			startOn: self)];
		yourself) 
			startOn: self)
]

{ #category : #'*Seamless-GTSupport' }
SeamlessProxy >> gtDebuggerEvaluatorIn: composite [
	<gtDebuggerPresentationOrder: 10>
	
	((SeamlessObjectVariablesBrowser from: self remotePeer) evaluatorIn: composite)
		title: 'Evaluator'
]

{ #category : #'*Seamless-GTSupport' }
SeamlessProxy >> gtDebuggerPresentationsIn: composite inContext: aGTInspector [
	| pragmas |
	pragmas := (Pragma 
				allNamed: #gtDebuggerPresentationOrder:
				from: self ghostClass 
				to: GHObjectGhost) asOrderedCollection.
	pragmas := pragmas sorted: [: x :y | (x argumentAt: 1) < (y argumentAt: 1)].
	self gtInspectorPresentationsFromPragmas: pragmas In: composite inContext: aGTInspector

]

{ #category : #'*Seamless-GTSupport' }
SeamlessProxy >> gtDebuggerRawIn: composite [
	<gtDebuggerPresentationOrder: 15>
	
	((SeamlessObjectVariablesBrowser from: self remotePeer) variablesIn: composite)
		title: 'Raw';
		send: #value.
			
	(GTProtoObjectVariablesBrowser new variablesIn: composite)
		title: 'Proxy';
		send: #value
]

{ #category : #'*Seamless-GTSupport' }
SeamlessProxy >> gtInspectorPresentationsFromPragmas: aCollection In: composite inContext: aGTInspector [

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
]

{ #category : #'*Seamless-GTSupport' }
SeamlessProxy >> gtInspectorPresentationsIn: composite inContext: aGTInspector [
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
]

{ #category : #'*Seamless-GTSupport' }
SeamlessProxy >> gtInspectorRawIn: composite [
	"This is the most basic presentation showing the state of the object"
	<gtInspectorPresentationOrder: 10>
	<gtInspectorTag: #basic>
	| browsers |
	browsers := {
		SeamlessObjectVariablesBrowser from: self remotePeer.
		GTProtoObjectVariablesBrowser new title: 'Proxy'}.
	self isConnectedToRemotePeer ifFalse: [browsers := browsers reversed].
		
	browsers do: [ :each | composite custom: each ]
]

{ #category : #'*Seamless-GTSupport' }
SeamlessProxy >> inspect [
	^ Smalltalk tools inspector inspect: self
]

{ #category : #'*Seamless-GTSupport' }
SeamlessProxy >> isRemoteDoItReceiver [
	^true
]
