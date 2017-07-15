tests
testProxyCreation

	| proxy |
	proxy := reference createProxy.
	
	proxy should beInstanceOf: SeamlessRemoteContext