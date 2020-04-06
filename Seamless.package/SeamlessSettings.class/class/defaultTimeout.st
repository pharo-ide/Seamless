accessing
defaultTimeout
	"Return the timeout to Seamless network communication"

	DefaultTimeout ifNil: [ DefaultTimeout := 3 ].
	^ DefaultTimeout