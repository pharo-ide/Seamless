Extension { #name : #Object }

{ #category : #'*Seamless' }
Object >> asLocalDeepCopy [
	^self
]

{ #category : #'*Seamless' }
Object >> asLocalObject [
	^self
]

{ #category : #'*Seamless' }
Object >> asTransferredByDeepCopy [
	^SeamlessDeepCopyContainer with: self
]

{ #category : #'*Seamless' }
Object >> asTransferredByValue [
	^SeamlessObjectValueContainer with: self
]

{ #category : #'*Seamless' }
Object >> createSeamlessReference [
	^SeamlessObjectReference new
]

{ #category : #'*Seamless' }
Object >> isOnlyDefaultTransferStrategyAllowed [
	^false
]

{ #category : #'*Seamless' }
Object >> isSeamlessProxy [
	^false
]

{ #category : #'*Seamless' }
Object >> isSeamlessReference [
	^false
]

{ #category : #'*Seamless' }
Object >> nameForSeamlessStatistics [

	^self class name
]

{ #category : #'*Seamless' }
Object >> prepareLocalSubstitutionIn: aSeamlessNetwork with: aTostMaterialization [

	aTostMaterialization atNextStepProcess: self
]

{ #category : #'*Seamless' }
Object >> prepareMethodTransferBy: anObjectTransporter [
	"this method called for each method literal when method is going to be transferred by value.
	GlobalVariable in that case (like class reference) could override this method to manage transporter to transfer class as well known object"
]

{ #category : #'*Seamless' }
Object >> prepareValueForTransferBy: anObjectTransporter [
	"Any object can define value object which will be transferred over network.
	By default it is object itself. 
	For details look at #prepareValueTransferBy: method comment"
	
	self prepareValueTransferBy: anObjectTransporter.
	
	^self
]

{ #category : #'*Seamless' }
Object >> prepareValueTransferBy: aSeamlessObjectTransporter [
	"By default transporter will send shallow copy of object to remote side.
	And all internal state will be transferred by their own transfer strategies.
	So we don't need to do anything here if we not have any internal state. 
	But if we have and we think that it is logical part of receiver value
	then we can mark this state to be transferred by value too: 
	
		aSeamlessObjectTransporter transferByValue: internalVariable 
	
	Look for example at OrderedCollection"
]

{ #category : #'*Seamless' }
Object >> printForSeamlessLog [
	^String streamContents: [ :s | 
		s 
			<< self class name;
			<< $(;
			<< self hash;
			<< ')>>'
	]
]

{ #category : #'*Seamless' }
Object >> remoteClass [
	^self class
]

{ #category : #'*Seamless' }
Object >> remotePrintString [
	^self printString
]

{ #category : #'*Seamless' }
Object >> seamlessDefaultTransferStrategy [
	^SeamlessTransferStrategy defaultByReference 
]

{ #category : #'*Seamless' }
Object >> seamlessIsBindingVisible: aString [
	"this methods is suitable for tools to detect if some binding visible by remote object.
	For example inspector evaluators could use it to distinguish local workspace variable 
	from normal accessible objects"
	
	(self class allInstVarNames includes: aString) ifTrue: [ ^true ].
	
	^(self class bindingOf: aString) notNil
]
