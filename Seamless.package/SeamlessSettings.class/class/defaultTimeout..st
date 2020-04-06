accessing
defaultTimeout: aNumber
	"Set the timeout to Seamless network communication"

	SeamlessSyncRequestContext waitTimeout: aNumber.
	^ DefaultTimeout := aNumber