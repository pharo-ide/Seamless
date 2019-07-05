Class {
	#name : #SeamlessDebuggerVariablesBrowser,
	#superclass : #GTDebuggerVariablesBrowser,
	#category : 'Seamless-GTSupport'
}

{ #category : #'private building' }
SeamlessDebuggerVariablesBrowser >> compareVariableTypeOf: x withVariable: y in: aContext [

	^ (self variableTypeOf: x in: aContext) < (self variableTypeOf: y in: aContext)
]

{ #category : #'private building' }
SeamlessDebuggerVariablesBrowser >> tagsForVariable: aString from: aContext [
	^ (#( 'self' 'thisContext' 'stack top') includes: aString) 
		ifTrue: [ 'implicit' ]
		ifFalse: [ self variableTypeOf: aString in: aContext ]
]

{ #category : #'private building' }
SeamlessDebuggerVariablesBrowser >> variableTypeOf: aString in: aContext [
	^ (aContext receiver class classThatDefinesInstanceVariable: aString) notNil
			ifTrue: [ 'attribute' ]
			ifFalse: [ (aContext method argumentNames includes: aString)
				ifTrue: [ 'parameter' ]
				ifFalse: [ 'temp' ] ]
			
	
]

{ #category : #'private building' }
SeamlessDebuggerVariablesBrowser >> variablesIn: composite [
	^ composite table
		showOnly: 50;
		shouldValidate: false;
		allowsRecursiveSearch: false;
		display: [ :context | self variablesFromContext: context ];
		column: 'Type'
			evaluated: [ '' ]
			width: 75
			tags: [ :assoc :context |
				self tagsForVariable: assoc key from: context ]
			sortedBy: [ :x :y | 
				self 
					compareVariableTypeOf: x key
					withVariable: y key
					in: ((self presentations first paneNamed: #variables) port: #entity) value];
		column: 'Variable' 
			evaluated: [:assoc | 
			[ Text fromString: assoc key asString ]
					on: Error
					do: [ Text string: 'error printing' attribute: TextColor red ] ]
			width: 175;
		column: 'Value' evaluated: [:assoc | 
			SeamlessObjectPrinter new asTruncatedTextFrom: assoc value];
		"send: #value;"
		morphicSelectionAct: [:list | list selection value browse ] 
			icon: GLMUIThemeExtraIcons glamorousBrowse 
			on: $b 
			entitled: 'Browse';
		morphicSelectionAct: [:list | list selection value inspect ] 
			icon: GLMUIThemeExtraIcons glamorousInspect 
			on: $i 
			entitled: 'Inspect';
		onChangeOfPort: #rawSelection 
			act: [ :aPresentation | 
				self debugger selectedVariableName: aPresentation rawSelection key ]
]
