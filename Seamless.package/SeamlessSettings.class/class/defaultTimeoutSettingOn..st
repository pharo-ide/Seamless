settings
defaultTimeoutSettingOn: aBuilder
	<systemsettings>
	(aBuilder group: #seamless)
		label: 'Seamless';
		parent: #tools;
		description: 'Seamless network settings';
		with: [ (aBuilder setting: #defaultTimeout)
				target: self;
				label: 'Default timeout network (secs)';
				default: '3' ]