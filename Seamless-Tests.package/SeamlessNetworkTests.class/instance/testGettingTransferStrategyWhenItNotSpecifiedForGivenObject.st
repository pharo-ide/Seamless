tests
testGettingTransferStrategyWhenItNotSpecifiedForGivenObject

	| actual object |
	object := Mock new.
		
	actual := network transferStrategyFor: object.
		
	actual should beReturnedFrom: [object seamlessDefaultTransferStrategy]