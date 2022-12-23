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
Object >> nameForSeamlessStatistics [

	^self class name
]

{ #category : #'*Seamless' }
Object >> prepareLocalSubstitutionIn: aSeamlessNetwork with: aSeamlessTransporter [

	aSeamlessTransporter atNextStepProcess: self
]

{ #category : #'*Seamless' }
Object >> prepareMethodTransferBy: aSeamlessTransporter [
	"This method is called for each method literal when method is going to be transferred by value.
	GlobalVariable in that case (like class reference) can override this method 
	to manage the transporter to transfer the class as well known object"
]

{ #category : #'*Seamless' }
Object >> prepareValueForTransferBy: aSeamlessTransporter [
	"Any object can define value object which will be transferred over network.
	By default it is object itself. 
	For details look at #prepareValueTransferBy: method comment"
	
	self prepareValueTransferBy: aSeamlessTransporter.
	
	^self
]

{ #category : #'*Seamless' }
Object >> prepareValueTransferBy: aSeamlessTransporter [
	"By default transporter will send shallow copy of object to remote side.
	And all internal state will be transferred by their own transfer strategies.
	So we don't need to do anything here if we not have any internal state. 
	But if we have and we think that it is logical part of receiver value
	then we can mark this state to be transferred by value too: 
	
		aSeamlessTransporter transferByValue: internalVariable 
	
	Look for example at OrderedCollection"
]

{ #category : #'*Seamless' }
Object >> printForSeamlessLog [
	^String streamContents: [ :s | 
		s 
			nextPutAll: self class name;
			nextPut: $(;
			print: self hash;
			nextPutAll: ')>>'
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
