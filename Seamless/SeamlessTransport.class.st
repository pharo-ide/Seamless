"
I am responsible for transfer of Seamless requests between Seamless peers.

I extend TostTransporter by defining appropriate format for data exchange. Particulary I use SeamlessSubstitutionTostFormat which implements object substitution according to given transfer strategies.

I have #default instance on class side with prepared formats which are required to transfer SeamlessRequest's. 
SeamlessNetwork uses my #default instance as a transprot for requests:

	transport sendObject: aSeamlessTequest  to: aBasysConnection
	transport receiveObjectFrom: aBasicConnection
"
Class {
	#name : #SeamlessTransport,
	#superclass : #TostTransport,
	#classInstVars : [
		'default'
	],
	#category : #'Seamless-Transport'
}

{ #category : #default }
SeamlessTransport class >> collectWellKnownClasses [

	| wellKnownClasses |
	wellKnownClasses := (SortedCollection new: 255) sortBlock: [:a :b | a name < b name].
	Object allSubclassesDo: [:each |
		each isWellKnownSeamlessClass ifTrue: [ wellKnownClasses add: each ]].

	^wellKnownClasses asArray
]

{ #category : #default }
SeamlessTransport class >> collectWellKnownObjects [

	^TostWellKnownObjectFormat default objects, 
		#(name printString asString class printOn: at: at:put: size do: select: collect: reject:
		instVarAt: instVarAt:put: value value: valueWithArguments: 
		selector methodClass isTestMethod argumentNames
		receiver method methodClass methodSelector isBlockContext home tempNames isDead sender debuggerMap outerContext outerMostContext closure
		allInstVarNames allSlots) asSet asArray
]

{ #category : #default }
SeamlessTransport class >> createDefault [

	^default := self new 
		formats: { 
			TostWellKnownObjectFormat on: self collectWellKnownObjects.
			TostDuplicatedObjectFormat new. 
			SeamlessSubstitutionTostFormat new.
			TostNewObjectOfWellKnownClassFormat on: self collectWellKnownClasses.	
			TostNewObjectOfDuplicatedClassFormat new. 
			TostNewObjectOfNewClassFormat new }
]

{ #category : #default }
SeamlessTransport class >> default [
	^default ifNil: [self createDefault]
]

{ #category : #'instance creation' }
SeamlessTransport class >> forTransferOver: aSeamlessNetwork by: aRemotePeer [
	^self new
		network: aSeamlessNetwork;
		remotePeer: aRemotePeer
]

{ #category : #default }
SeamlessTransport class >> resetDefault [

	^default := nil
]

{ #category : #api }
SeamlessTransport >> newTransporterOn: aBasysConnection [

	^SeamlessTransporter using: self onConnection: aBasysConnection
]
