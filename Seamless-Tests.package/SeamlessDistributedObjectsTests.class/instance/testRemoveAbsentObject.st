tests
testRemoveAbsentObject

	| object |

	object := Object new.
		
	distributedObjects remove: object.
	
	distributedObjects objectsToReferences should be isEmpty.
	distributedObjects referencesToObjects should be isEmpty