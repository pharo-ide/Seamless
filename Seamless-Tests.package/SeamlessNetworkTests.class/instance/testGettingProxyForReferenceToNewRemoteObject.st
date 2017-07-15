tests
testGettingProxyForReferenceToNewRemoteObject

	| actual distributedObjects reference |
	distributedObjects := Mock new.
	reference := Mock new.
	network distributedObjects: distributedObjects.
	
	(distributedObjects stub at: reference ifAbsentUseProxy: Any) 
		will: [:ref :proxyBlock | proxyBlock value ].
	reference stub createProxy willReturn: #proxy.
	
	actual := network objectFor: reference.
	
	actual should be: #proxy