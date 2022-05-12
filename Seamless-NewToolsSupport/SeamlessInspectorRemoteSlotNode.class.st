Class {
	#name : #SeamlessInspectorRemoteSlotNode,
	#superclass : #StInspectorSlotNode,
	#category : #'Seamless-NewToolsSupport'
}

{ #category : #accessing }
SeamlessInspectorRemoteSlotNode >> rawValue [

	^  self hostObject readRemoteSlot: self slot
]

{ #category : #accessing }
SeamlessInspectorRemoteSlotNode >> save: anObject [

	self hostObject writeRemoteSlot: self slot 	value: anObject
]
