tests
testProxyCreation

	| proxy |
	proxy := reference createProxy.
	
	proxy should be: reference objectCopy
