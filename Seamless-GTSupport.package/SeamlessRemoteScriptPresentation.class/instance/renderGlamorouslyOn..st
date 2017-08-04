rendering
renderGlamorouslyOn: aRenderer
	self registerAnnouncements.
	^ SeamlessRemoteScriptRenderer render: self from: aRenderer