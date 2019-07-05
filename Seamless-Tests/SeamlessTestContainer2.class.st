Class {
	#name : #SeamlessTestContainer2,
	#superclass : #Object,
	#instVars : [
		'name',
		'content'
	],
	#category : 'Seamless-Tests'
}

{ #category : #'instance creation' }
SeamlessTestContainer2 class >> named: aString with: anObject [
	^self new 
		name: aString;
		content: anObject
]

{ #category : #'instance creation' }
SeamlessTestContainer2 class >> with: anObject [
	^self new 
		content: anObject
]

{ #category : #accessing }
SeamlessTestContainer2 >> content [
	^ content
]

{ #category : #accessing }
SeamlessTestContainer2 >> content: anObject [
	content := anObject
]

{ #category : #accessing }
SeamlessTestContainer2 >> name [
	^ name
]

{ #category : #accessing }
SeamlessTestContainer2 >> name: anObject [
	name := anObject
]

{ #category : #printing }
SeamlessTestContainer2 >> printOn: aStream [
	super printOn: aStream.
	
	aStream nextPut: $(.
	name printOn: aStream.
	aStream nextPut: $).
]
