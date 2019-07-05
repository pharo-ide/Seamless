Extension { #name : #GLMRubricSmalltalkTextModel }

{ #category : #'*Seamless-Pharo5Support' }
GLMRubricSmalltalkTextModel >> bindingOf: aSymbol [

	^ self bindingsStrategy cull: self variableBindings cull: aSymbol cull: self
]
