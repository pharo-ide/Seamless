Extension { #name : #SeamlessProxy }

{ #category : #'*Seamless-NewToolsSupport' }
SeamlessProxy >> remoteInspection [
	"This is the most basic presentation showing the state of the object"
	<inspectorPresentationOrder: 1000 title: 'Remote'>

	^ SeamlessRemoteObjectInspection on: self
]
