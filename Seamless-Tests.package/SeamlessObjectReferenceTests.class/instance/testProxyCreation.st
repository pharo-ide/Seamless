tests
testProxyCreation

	| proxy |
	proxy := reference createProxy.

	proxy isSeamlessProxy should be: true