Extension { #name : #SeamlessProxy }

{ #category : #'*Seamless-NewToolsSupport' }
SeamlessProxy class >> compilerClass [

	^SeamlessRemoteClassCompiler
]

{ #category : #'*Seamless-NewToolsSupport' }
SeamlessProxy >> inspect [
	^ Smalltalk tools inspector inspect: self
]

{ #category : #'*Seamless-NewToolsSupport' }
SeamlessProxy >> isRemoteDoItReceiver [
	^true
]

{ #category : #'*Seamless-NewToolsSupport' }
SeamlessProxy >> remoteInspection [
	"This is the most basic presentation showing the state of the object"
	<inspectorPresentationOrder: 1000 title: 'Remote'>

	^ SeamlessRemoteObjectInspection on: self
]
