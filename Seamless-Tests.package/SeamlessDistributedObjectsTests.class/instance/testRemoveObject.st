tests
testRemoveObject

	| object |

	object := Object new.
	
	distributedObjects referenceFor: object ifNewUse: [ SeamlessObjectReference new ].
		
	distributedObjects remove: object.
	
	distributedObjects objectsToReferences should be isEmpty.
	distributedObjects referencesToObjects should be isEmpty