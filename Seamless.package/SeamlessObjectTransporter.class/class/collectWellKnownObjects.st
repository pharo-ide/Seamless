default
collectWellKnownObjects

	^TostWellKnownObjectFormat default objects, 
		#(name printString asString class printOn: at: at:put: size do: select: collect: reject:
		instVarAt: instVarAt:put: value value: valueWithArguments: 
		selector methodClass isTestMethod argumentNames
		receiver method methodClass methodSelector isBlockContext home tempNames isDead sender debuggerMap outerContext outerMostContext closure
		allInstVarNames allSlots) asSet asArray