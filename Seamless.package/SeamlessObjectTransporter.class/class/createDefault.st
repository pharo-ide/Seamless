default
createDefault

	^default := self new 
		formats: { 
			TostWellKnownObjectFormat on: self collectWellKnownObjects.
			TostDuplicatedObjectFormat new. 
			SeamlessSubstitutionTostFormat new.
			TostNewObjectOfWellKnownClassFormat on: self collectWellKnownClasses.	
			TostNewObjectOfDuplicatedClassFormat new. 
			TostNewObjectOfNewClassFormat new }