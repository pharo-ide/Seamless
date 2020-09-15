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
					repository: 'github://pharo-ide/Basys:v1.0.4';
					loads: 'Core' ];
			project: 'BasysTests' copyFrom: 'Basys' with: [
				spec loads: 'Tests'];
			"------------"				
			baseline: 'ObjectStatistics' with: [
				spec
					repository: 'github://pharo-ide/ObjectStatistics:v1.0.2';
					loads: 'Core' ];
			project: 'ObjectStatisticsTests' copyFrom: 'ObjectStatistics' with: [
				spec loads: 'default' ];				
			"------------"								
			baseline: 'Ghost' with: [
				spec
					repository: 'github://pharo-ide/Ghost:v5.0.2';
					loads: 'ObjectGhost' ];
			project: 'GhostTests' copyFrom: 'Ghost' with: [
				spec loads: 'default'];
			"------------"
			baseline: 'ReadWriteLock' with: [
				spec
					repository: 'github://pharo-ide/ReadWriteLock:v1.0.0';
					loads: 'Core'];
			project: 'ReadWriteLockTests' copyFrom: 'ReadWriteLock' with: [
				spec loads: 'Tests'];
			"------------"				
			baseline: 'TostSerializer' with: [
				spec
					repository: 'github://pharo-ide/TostSerializer:v2.0.0';
					loads: 'Core'];
			project: 'TostSerializerTests' copyFrom: 'TostSerializer' with: [
				spec loads: 'Tests'];
			"------------"						
			baseline: 'Mocketry' with: [
				spec repository: 'github://dionisiydk/Mocketry:v6.0.3' ].
							
		spec 
			package: 'Seamless' with: [
				spec requires: #('Basys' 'ReadWriteLock' 'TostSerializer' 'Ghost'). ];
			package: 'Seamless-Tests' with: [spec requires: #('Mocketry' 'Seamless' 'BasysTests' 'ReadWriteLockTests' 'TostSerializerTests' 'GhostTests')];
			package: 'Seamless-GTSupport' with: [spec requires: #('Seamless')];
			package: 'Seamless-Logging' with: [spec requires: #('ObjectStatistics' 'Seamless')].
		spec
			group: 'default' with: #('Core' 'Tests' 'Seamless-GTSupport' 'Seamless-Logging' 'ObjectStatisticsTests');
			group: 'Core' with: #('Seamless' );
			group: 'Tests' with: #('Seamless-Tests')].
		
	spec for: #'pharo5.x' do: [
		( #('Pharo6' 'Pharo 6') anySatisfy: [ :each | Smalltalk version beginsWith: each] ) 
			ifFalse: [ 
				spec package: 'Seamless-Pharo5Support' with: [spec requires: #('Seamless')].
				spec group: 'Core' with: #('Seamless' 'Seamless-Pharo5Support')]
	]	

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
