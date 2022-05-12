Class {
	#name : #SeamlessRemoteObjectInspection,
	#superclass : #GHGhostRawInspection,
	#category : #'Seamless-NewToolsSupport'
}

{ #category : #accessing }
SeamlessRemoteObjectInspection >> inspectorNodes [

	^{ StInspectorSelfNode hostObject: self model }, self inspectorRemoteNodes 
]

{ #category : #accessing }
SeamlessRemoteObjectInspection >> inspectorRemoteNodes [

	| allSlots |
	allSlots := self model remoteClass allSlots asLocalObject.
	^allSlots collect: [ :each | 
			SeamlessInspectorRemoteSlotNode hostObject: self model slot: each ]
]
