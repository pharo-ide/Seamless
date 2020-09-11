"
I am responsible for transfer of Seamless requests between Seamless peers.

I extend TostTransporter by defining appropriate format for data exchange. Particulary I use SeamlessSubstitutionTostFormat  which implements object substitution according to their transfer strategies.

I have default instance on class side with prepared formats which describe well known objects and classes.
SeamlessNetwork uses my default instance as transprot to instantiate concrete transporter instances for particular remote peer. 

	transporter newTransporterFor: aSeamlessNetwork toTransferBy: aRemotePeer

SeamlessNetwork uses me to send and receive requests to and from connections:

	transporter sendRequest: anObject by: aBasysConnection
	transporter receiveRequestBy: aBasicConnection
	
I maintain objectSubstitutions dictionary to control how specific objects should be transferred. Transport strategies command me for this using following messages:

	 transporter transferByValue: anObject
	 transporter transfer: anObject byReference: creationBlock
	 transporter transfer: anObject byWellKnownObjectNamed:
	 transporter transferByDeepCopy: anObject

Last command activates deep copy transfer strategy for particular object. I keep them in separate dictionary objectsByDeepCopy. 
Idea that any reference from given object subgraph should be transferred by value which means that network strategies will not be used for them.

To read objects from connections substitutions are processed specifically. Loaded from stream objects are asked to create local substitutions which will be injected into materialized object graph instead of them.
 
	transporter prepareLocalSubstitutionOf: aLoadedObject with: aTostMaterialization.  

Alsow I implement optimized encoding for SeamlessObjectReference's to miminize size of objects on stream. When transferred references belongs to sender or receiver peers I encode them without ownerPeerId property.  I extract it value from participating peers. Look at methods:

- writeObjectReference: anObjectReference with: aTostSerialization
- readObjectReference: anObjectReference with: aTostMaterialization

Internal Representation and Key Implementation Points.

    Instance Variables
	network:		<SeamlessNetwork>
	remotePeer:		<BasysRemotePeer>
	objectSubstitutions:		<IdentityDictionary>
	objectsByDeepCopy:		<IdentityDictionary>
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
