Class {
	#name : #SeamlessTestContainer,
	#superclass : #Object,
	#instVars : [
		'name',
		'content'
	],
	#category : #'Seamless-Tests'
}

{ #category : #'instance creation' }
SeamlessTestContainer class >> named: aString with: anObject [
	^self new 
		name: aString;
		content: anObject
]

{ #category : #'instance creation' }
SeamlessTestContainer class >> with: anObject [
	^self new 
		content: anObject
]

{ #category : #accessing }
SeamlessTestContainer >> content [
	^ content
]

{ #category : #accessing }
SeamlessTestContainer >> content: anObject [
	content := anObject
]

{ #category : #accessing }
SeamlessTestContainer >> name [
	^ name
]

{ #category : #accessing }
SeamlessTestContainer >> name: anObject [
	name := anObject
]

{ #category : #printing }
SeamlessTestContainer >> printOn: aStream [
	super printOn: aStream.
	 
	aStream nextPut: $(.
	name printOn: aStream.
	aStream nextPut: $).
]
