Class {
	#name : #SeamlessRemoteObjectInspection,
	#superclass : #GHGhostRawInspection,
	#category : #'Seamless-NewToolsSupport'
}

{ #category : #accessing }
SeamlessRemoteObjectInspection >> inspectorNodes [

	^self inspectorNodesFor: self model
]

{ #category : #accessing }
SeamlessRemoteObjectInspection >> inspectorNodesFor: anObject [ 

	| allSlots nodes |
	allSlots := anObject remoteClass allSlots asLocalObject.
	nodes := allSlots collect: [ :each | 
			SeamlessInspectorRemoteSlotNode hostObject: anObject slot: each ].
		
	^{ StInspectorSelfNode hostObject: anObject }, nodes
]

{ #category : #accessing }
SeamlessRemoteObjectInspection >> setAttributeTable [

	attributeTable
		roots: self inspectorNodes;
		children: [ :node | self inspectorNodesFor: node value ]
]
