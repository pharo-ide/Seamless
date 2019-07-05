Class {
	#name : #SeamlessObjectVariablesBrowser,
	#superclass : #GTObjectVariablesBrowser,
	#instVars : [
		'remotePeer'
	],
	#category : 'Seamless-GTSupport'
}

{ #category : #'instance creation' }
SeamlessObjectVariablesBrowser class >> from: aRemotePeer [
	^self new 
		remotePeer: aRemotePeer
]

{ #category : #'private building' }
SeamlessObjectVariablesBrowser >> basicVariableValuePairsFor: aSeamlessProxy [
	
	aSeamlessProxy isSeamlessProxy ifFalse: [ 
		^ self localObjectVariableValuePairsFor: aSeamlessProxy].
	
	^ (aSeamlessProxy remoteClass allInstVarNames asLocalObject 
			collectWithIndex: [ :ivName :index | 
				ivName -> (aSeamlessProxy remoteInstVarAt: index) ]) 
					sort
			
]

{ #category : #'private building' }
SeamlessObjectVariablesBrowser >> evaluatorIn: composite [
	^ (composite custom: (SeamlessRemoteScriptPresentation remotePeer: remotePeer))
		doItReceiver: [ :object | object ];
		smalltalkClass: [ :object | object remoteClass ];
		display: [ :object | 
			String streamContents: [ :stream | 
				stream 
					nextPutAll: (self printStringOf: object);
					cr;
					nextPutAll: (GTSnippets snippetAt: object class)] ];
		onChangeOfPort: #text act: [ :textPresentation :object |
				GTSnippets 
					snippetAt: object class 
					put: (self stringWithoutInitialCommentFrom: textPresentation text asString).
				 textPresentation clearUserEdits ];
		installDefaultSelectionActions
]

{ #category : #'private-building' }
SeamlessObjectVariablesBrowser >> localObjectVariableValuePairsFor: anObject [

	^ anObject gtInspectorVariableValuePairs asOrderedCollection 
]

{ #category : #'private building' }
SeamlessObjectVariablesBrowser >> printStringOf: aSeamlessProxy [

	aSeamlessProxy isSeamlessProxy ifFalse: [ ^super printStringOf: aSeamlessProxy ].
	
	^aSeamlessProxy remotePrintString asComment
]

{ #category : #accessing }
SeamlessObjectVariablesBrowser >> remotePeer [
	^ remotePeer
]

{ #category : #accessing }
SeamlessObjectVariablesBrowser >> remotePeer: anObject [
	remotePeer := anObject
]

{ #category : #'private building' }
SeamlessObjectVariablesBrowser >> updateInstanceVariable: aSymbol from: anObject basedOn: aString [
	|result|

	(anObject remoteClass hasInstVarNamed: aSymbol) 
		ifFalse: [ ^ self ].
	result := anObject remoteClass compiler
			source: aString;
			context: nil;
			receiver: anObject;
			failBlock: [ ^ self ];
			evaluate.

	anObject writeSlotNamed: aSymbol value: result.
	
]

{ #category : #'private building' }
SeamlessObjectVariablesBrowser >> variableValuePairsFor: anObject [

	^ (self basicVariableValuePairsFor: anObject) asOrderedCollection 
		addFirst: 'self' -> anObject; 
		yourself
]

{ #category : #'private building' }
SeamlessObjectVariablesBrowser >> variablesIn: composite [
	^ composite table
		showOnly: 50;
		shouldValidate: false;
		allowsRecursiveSearch: false;
		children: [ :assoc | 
			assoc key = 'self'
				ifTrue: [ #() ]
				ifFalse: [ self variableValuePairsFor: assoc value ] ];
		icon: [ :assoc | self iconFor: assoc value ];
		display: [ :anObject | 
			self rebuildCacheFor: anObject.
			self variableValuePairsFor: anObject ];
		column: 'Variable' 
			evaluated: [:assoc | '  ', (GTObjectPrinter new asNonTruncatedTextFrom: assoc key) ];
		column: 'Value' 
			evaluated: [:assoc | SeamlessObjectPrinter new asTruncatedTextFrom: assoc value ]
			"following leads to empty value in column. So it is disabled until fix in GT will be ready.
			modified: [:newValue :assoc :presentation | 
				self updateInstanceVariable: assoc key from: presentation entity basedOn: newValue.
				presentation update ]";
		morphicSelectionAct: [:list | list selection value browse ] 
			icon: GLMUIThemeExtraIcons glamorousBrowse 
			on: $b 
			entitled: 'Browse';
		morphicSelectionAct: [:list | list selection value inspect ] 
			icon: GLMUIThemeExtraIcons glamorousInspect 
			on: $i 
			entitled: 'Inspect';
		selectionAct: [:list | 
			((list selection pointersToExcept: { list selection })
									reject: [ :each | each pointsOnlyWeaklyTo: list selection ]) inspect ] 
			on: $t
			entitled: 'Open pointers to';
		dynamicActionsOnSelection: [ :presentation |
			(presentation entity class hasInstVarNamed: presentation rawSelection key)
				ifTrue: [ 
					{
						GLMGenericAction new 
								action: [:list | self systemNavigation browseAllAccessesTo: list rawSelection key from: list entity class ]; 
								title: 'List methods using this variable'.
						GLMGenericAction new 
								action: [:list | self systemNavigation browseAllStoresInto: list rawSelection key from: list entity class ]; 
								title: 'List methods storing into this variable'.		
					}
					]
				ifFalse: [ #() ] ]
]
