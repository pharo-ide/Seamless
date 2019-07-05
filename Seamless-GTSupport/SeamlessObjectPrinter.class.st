Class {
	#name : #SeamlessObjectPrinter,
	#superclass : #GTObjectPrinter,
	#category : 'Seamless-GTSupport'
}

{ #category : #printing }
SeamlessObjectPrinter >> asNonTruncatedTextFrom: anObject [
	^ [ Text fromString: (anObject remotePrintString replaceAll: String cr with: String space) ] 
			on: Error 
			do: [ Text string: 'error printing' attribute: TextColor red ]
]

{ #category : #printing }
SeamlessObjectPrinter >> asTruncatedTextFrom: anObject [
	^ [ Text fromString: (anObject remotePrintString replaceAll: String cr with: String space) ]
		on: Error
		do: [ Text string: 'error printing' attribute: TextColor red ]
]
