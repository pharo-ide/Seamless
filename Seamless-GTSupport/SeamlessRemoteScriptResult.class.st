Class {
	#name : #SeamlessRemoteScriptResult,
	#superclass : #Object,
	#instVars : [
		'value'
	],
	#category : 'Seamless-GTSupport'
}

{ #category : #'instance creation' }
SeamlessRemoteScriptResult class >> value: anObjectOrProxy [
	^self new 
		value: anObjectOrProxy
]

{ #category : #printing }
SeamlessRemoteScriptResult >> printString [
	^value remotePrintString 
]

{ #category : #accessing }
SeamlessRemoteScriptResult >> value [
	^ value
]

{ #category : #accessing }
SeamlessRemoteScriptResult >> value: anObject [
	value := anObject
]
