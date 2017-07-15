printing
asTruncatedTextFrom: anObject
	^ [ Text fromString: (anObject remotePrintString replaceAll: String cr with: String space) ]
		on: Error
		do: [ Text string: 'error printing' attribute: TextColor red ]