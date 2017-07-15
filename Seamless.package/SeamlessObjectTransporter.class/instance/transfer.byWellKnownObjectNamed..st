sending-controlling
transfer: anObject byWellKnownObjectNamed: globalName

	objectSubstitutions at: anObject put: (SeamlessWellKnownObject named: globalName)