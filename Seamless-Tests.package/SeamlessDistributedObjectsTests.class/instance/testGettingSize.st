tests
testGettingSize

	| object |

	object := Object new.
	
	distributedObjects referenceFor: object ifNewUse: [ SeamlessObjectReference new ].
	
	distributedObjects should haveSize: 1