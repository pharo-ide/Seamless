Class {
	#name : #BaselineOfSeamless,
	#superclass : #BaselineOf,
	#category : #BaselineOfSeamless
}

{ #category : #baselines }
BaselineOfSeamless >> baseline: spec [
	<baseline>
	spec for: #'common' do: [
		spec postLoadDoIt: #postLoad.
		spec 
			baseline: 'Basys' with: [
				spec
					repository: 'github://pharo-ide/Basys:v2.0.1';
					loads: 'Core' ];
			project: 'BasysTests' copyFrom: 'Basys' with: [
				spec loads: 'Tests'];
			"------------"				
			baseline: 'ObjectStatistics' with: [
				spec
					repository: 'github://pharo-ide/ObjectStatistics:v2.0.1';
					loads: 'Core' ];
			project: 'ObjectStatisticsTests' copyFrom: 'ObjectStatistics' with: [
				spec loads: 'default' ];				
			"------------"								
			baseline: 'Ghost' with: [
				spec
					repository: 'github://pharo-ide/Ghost:v6.0.2';
					loads: 'ObjectGhost' ];
			project: 'GhostTests' copyFrom: 'Ghost' with: [
				spec loads: 'default'];
			"------------"
			baseline: 'ReadWriteLock' with: [
				spec
					repository: 'github://pharo-ide/ReadWriteLock:v3.0.0';
					loads: 'Core'];
			project: 'ReadWriteLockTests' copyFrom: 'ReadWriteLock' with: [
				spec loads: 'Tests'];
			"------------"				
			baseline: 'TostSerializer' with: [
				spec
					repository: 'github://pharo-ide/TostSerializer:v2.0.1';
					loads: 'Core'];
			project: 'TostSerializerTests' copyFrom: 'TostSerializer' with: [
				spec loads: 'Tests'];
			"------------"						
			baseline: 'Mocketry' with: [
				spec repository: 'github://dionisiydk/Mocketry:v7.0.2' ].
							
		spec 
			package: 'Seamless' with: [
				spec requires: #('Basys' 'ReadWriteLock' 'TostSerializer' 'Ghost'). ];
			package: 'Seamless-Tests' with: [spec requires: #('Mocketry' 'Seamless' 'BasysTests' 'ReadWriteLockTests' 'TostSerializerTests' 'GhostTests')];
			package: 'Seamless-NewToolsSupport' with: [spec requires: #('Seamless')];
			package: 'Seamless-Logging' with: [spec requires: #('ObjectStatistics' 'Seamless')].
		spec
			group: 'default' with: #('Core' 'Tests' 'Seamless-NewToolsSupport' 'Seamless-Logging' 'ObjectStatisticsTests');
			group: 'Core' with: #('Seamless' );
			group: 'Tests' with: #('Seamless-Tests')]
		

]

{ #category : #baselines }
BaselineOfSeamless >> postLoad [

	(self class environment classNamed: #SeamlessTransport) resetDefault
]

{ #category : #accessing }
BaselineOfSeamless >> projectClass [
	^ [ self class environment at: #MetacelloCypressBaselineProject ]
		on: NotFound
		do: [ super projectClass ]
]
