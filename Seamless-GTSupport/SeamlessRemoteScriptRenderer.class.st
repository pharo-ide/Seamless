Class {
	#name : #SeamlessRemoteScriptRenderer,
	#superclass : #GLMMorphicPharoScriptRenderer,
	#category : 'Seamless-GTSupport'
}

{ #category : #private }
SeamlessRemoteScriptRenderer >> findCustomBindingFor: aString in: anObject existing: currentBindings [

	(anObject seamlessIsBindingVisible: aString) ifTrue: [ ^nil ].

	(currentBindings includesKey: aString) ifFalse: [ 
		currentBindings add: (SeamlessRemoteWorkspaceVariable key: aString asSymbol) ].
	
	^currentBindings associationAt: aString
]

{ #category : #'events-alarms' }
SeamlessRemoteScriptRenderer >> popupPrint [
	"Evaluates selected code and prints it in a popper"
	textMorph textArea editor highlightEvaluateAndDo: [ :result | 
		textMorph shoutStyler style: textMorph text.
		GLMPrintPopper new 
			openFromRubric: textMorph textArea withResult: (SeamlessRemoteScriptResult value: result) ]
]

{ #category : #private }
SeamlessRemoteScriptRenderer >> workspaceBindingsStrategy [
	^ [ :currentBindings :aString :aTextModel | 
		self findCustomBindingFor: aString in: aTextModel doItReceiver existing: currentBindings ]
]
