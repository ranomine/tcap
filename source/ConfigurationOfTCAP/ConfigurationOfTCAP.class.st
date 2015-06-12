Class {
	#name : #ConfigurationOfTCAP,
	#superclass : #Object,
	#instVars : [
		'project'
	],
	#classVars : [
		'LastVersionLoad'
	],
	#category : #ConfigurationOfTCAP
}

{ #category : #'development support' }
ConfigurationOfTCAP class >> DevelopmentProcess [

"DEVELOPMENT Process
	- load current version:
	  	(self project version: #stable) load: 'ALL'.
	- open new version for development:
		self createNewDevelopmentVersion
	- update the the development version to match mcz file versions
		self updateToLatestPackageVersions: '- fixed bug uvw'
	- do development and periodically save mcz files and update configuration
		self saveModifiedPackages: '- fixed bug xyz'
	- do development and periodically save mcz files and configuration until ready for release
		self saveModifiedPackagesAndConfiguration: '- fixed bug xyz'
	- save configuration
		self saveConfiguration: commitMessage '- checkpoint configuration'
RELEASE Process
	- mark development version as release:
		self releaseDevelopmentVersion: 'commit comment'
	- copy configuration for general access for Squeak and Pharo:
		self copyToSqueakSource.
	- copy configuration for general access for GLASS (Dale is willing to test and release for GLASS):
		self copyToGemSource.
"
]

{ #category : #private }
ConfigurationOfTCAP class >> bootstrapPackage: aString from: aPath [ 
	| repository version |
	repository := MCHttpRepository
				location: aPath
				user: ''
				password: ''.
	repository
		versionReaderForFileNamed: aString , '.mcz'
		do: [:reader | 
			version := reader version.
			version load.
			version workingCopy repositoryGroup addRepository: repository]
]

{ #category : #'development support' }
ConfigurationOfTCAP class >> compareVersions [
	"Compare the current #stable version to current #development version"

	"self compareVersions"

	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	((Smalltalk at: #MetacelloToolBox) compareVersionsIn: self) inspect

]

{ #category : #'development support' }
ConfigurationOfTCAP class >> copyToGemSource [
	"Copy the current configuration mcz file to http://seaside.gemstone.com/ss/MetacelloRepository"

	"Note you before copying config to GemSource, you should have tested the release in GLASS.
	 You also need to have commit rights to the GemSource repository."

	"self copyToGemSource"

	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	(Smalltalk at: #MetacelloToolBox) copyConfiguration: self to: 'http://seaside.gemstone.com/ss/MetacelloRepository'
]

{ #category : #'development support' }
ConfigurationOfTCAP class >> copyToSqueakSource [
	"Copy the current configuration mcz file to http://www.squeaksource.com/MetacelloRepository"

	"self copyToSqueakSource"

	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	(Smalltalk at: #MetacelloToolBox) copyConfiguration: self to: 'http://www.squeaksource.com/MetacelloRepository'
]

{ #category : #'development support' }
ConfigurationOfTCAP class >> createNewBaselineVersion [
	"Create a new baseline version based upon #stable version's baseline.
	 A new baseline should be created if new packages have been added or package dependencies have changed."

	"self createNewDevelopmentVersion"
	
	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	(Smalltalk at: #MetacelloToolBox) createNewBaselineVersionIn: self description: ''

]

{ #category : #'development support' }
ConfigurationOfTCAP class >> createNewDevelopmentVersion [
	"Create a new development version using the #stable version as model."

	"self createNewDevelopmentVersion"
	
	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	(Smalltalk at: #MetacelloToolBox) createNewDevelopmentVersionIn: self description: ''
]

{ #category : #private }
ConfigurationOfTCAP class >> ensureMetacello [
	"Bootstrap Gofer (if necessary), load latest mcz file for ConfigurationOfMetacello (using old 
	 Gofer API), then load the latest version of Metacello itself."

	Smalltalk at: #MetacelloProject ifAbsent: [ | error |
		"list of repositories to try, in case primary repository is not accessible"
		(Array 
			with: 'http://www.squeaksource.com/MetacelloRepository' 
			with: 'http://seaside.gemstone.com/ss/metacello') do: [:repositoryUrl |
				([
					Smalltalk at: #Gofer ifAbsent: [
						"Current version of Gofer from which to bootstrap - as of 1.0-beta.21"
						self bootstrapPackage: 'Gofer-Core-lr.115' from: repositoryUrl ].
					Smalltalk at: #Gofer ifPresent: [:goferClass | | gofer |
						gofer := goferClass new
							url: repositoryUrl;
							yourself.
						[ gofer addPackage: 'ConfigurationOfMetacello' ] on: Warning do: [:ex | ex resume ].
						gofer load ]]
							on: Error
							do: [ :ex |
								error := ex.
								Transcript 
									cr; 
									show: 'failed ensureMetacello: ';
									show: ex description printString;
									show: '...retrying'.
								"try again"
								ex return: nil ]) ~~ nil
					ifTrue: [
						"load 'default' group of Metacello"
						(Smalltalk at: #ConfigurationOfMetacello) perform: #load.
						^self ]].
		"shouldn't get here unless the load failed ... throw an error"
		self error: 'retry with alternate repository failed: ', error description printString ]
]

{ #category : #'metacello tool support' }
ConfigurationOfTCAP class >> isMetacelloConfig [
	"Answer true and the Metacello tools will operate on you"
	
	^true
]

{ #category : #'metacello tool support' }
ConfigurationOfTCAP class >> lastMetacelloVersionLoad [
	"Answer the last version loaded and the list of packages loaded for that version."

	LastVersionLoad == nil ifTrue: [ LastVersionLoad := nil -> 'default' ].
	^LastVersionLoad
]

{ #category : #loading }
ConfigurationOfTCAP class >> loadBleedingEdge [
	^ (self project version: #bleedingEdge) load
]

{ #category : #loading }
ConfigurationOfTCAP class >> loadDevelopment [
	^ (self project version: #development) load
]

{ #category : #'metacello tool support' }
ConfigurationOfTCAP class >> metacelloVersion: versionString loads: anArrayOrString [
	"Stash the last version loaded and the list of packages loaded for that version. The list
	 of packages will be used by the tools when doing 'Load Package Version'"

	LastVersionLoad := versionString -> anArrayOrString
]

{ #category : #accessing }
ConfigurationOfTCAP class >> project [

	^self new project
]

{ #category : #'development support' }
ConfigurationOfTCAP class >> releaseDevelopmentVersion: commitMessage [
	"Release #development version (set version blessing to #release), update the #development and #stable symbolic versions and save the configuration."

	"self releaseDevelopmentVersion: '- release version 1.0.2'"

	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	(Smalltalk at: #MetacelloToolBox) releaseDevelopmentVersionIn: self description: commitMessage
]

{ #category : #'development support' }
ConfigurationOfTCAP class >> saveConfiguration: commitMessage [
	"Save the configuration."

	"self saveConfiguration: '- fixed bug'"

	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	(Smalltalk at: #MetacelloToolBox) saveConfigurationPackageFor: self name asString description: commitMessage
]

{ #category : #'development support' }
ConfigurationOfTCAP class >> saveModifiedPackages: commitMessage [
	"Save modified mcz files and update the configuration."

	"self saveModifiedPackages: '- fixed bug'"

	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	(Smalltalk at: #MetacelloToolBox) saveModifiedPackagesIn: self description:  commitMessage
]

{ #category : #'development support' }
ConfigurationOfTCAP class >> saveModifiedPackagesAndConfiguration: commitMessage [
	"Save modified mcz files, update and then save the configuration."

	"self saveModifiedPackagesAndConfiguration: '- fixed bug'"

	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	(Smalltalk at: #MetacelloToolBox) saveModifiedPackagesAndConfigurationIn: self description: commitMessage
]

{ #category : #loading }
ConfigurationOfTCAP class >> update [
	self project updateProject.
	self loadDevelopment
]

{ #category : #'development support' }
ConfigurationOfTCAP class >> updateToLatestPackageVersions: descriptionString [
	"Updates mcz file versions in current version"

	"self updateToLatestPackageVersions: '- latest mcz files for 1.0.4'"

	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	((Smalltalk at: #MetacelloToolBox) updateToLatestPackageVersionsIn: self description: descriptionString) isEmpty
		ifTrue: [ self inform: 'All specs up to date' ]
]

{ #category : #'development support' }
ConfigurationOfTCAP class >> validate [
	"Check the configuration for Errors, Critical Warnings, and Warnings (see class comment for MetacelloMCVersionValidator for more information). 
	Errors identify specification issues that will result in unexpected behaviour when you load the configuration. 
	Critical Warnings identify specification issues that may result in unexpected behavior when you load the configuration.
	Warnings identify specification issues that are technically correct, but are worth take a look at."
	
	"self validate"

	"Note: you need 1.0-beta.28 or later for the class MetacelloToolBox"

	self ensureMetacello.
	^ ((Smalltalk at: #MetacelloToolBox) validateConfiguration: self debug: #() recurse: false) explore
]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> baseline01: spec [ 
        <version: '0.1-baseline'>
        
	spec for: #common do: [
		spec blessing: #baseline.
                spec repository: 'http://smalltalkhub.com/mc/osmocom/Osmocom/main'.    
                spec 
				package: 'TCAP-Core' with: [ spec requires: #('ASN1-Tool' 'ASN1-Tests-Builder' 'MAP-Core' 'ASN1-Tests-Tool' 'Phexample')];
				package: 'MAP-Core' with: [ spec requires: #('ROS-Core' )];
				package: 'ROS-Core' with: [ spec requires: #('ASN1-Tool') ];
				package: 'Q787-TestSpec' with: [ spec requires: #('TCAP-Core') ].
			spec
				project: 'Phexample' with: [
					spec
						className: 'ConfigurationOfPhexample';
						versionString: '1.2';
						repository: 'http://smalltalkhub.com/mc/Phexample/Phexample/main' ].	
			spec
				project: 'Osmocom' with: [
					spec
						className: 'ConfigurationOfOsmocom';
						versionString: #'bleedingEdge';
						file: 'ConfigurationOfOsmocom';
						repository: 'http://smalltalkhub.com/mc/osmocom/Osmocom/main' ].
			spec
				project: 'ASN1' with: [
					spec
						className: 'ConfigurationOfASN1';
						versionString: #development;
						file: 'ConfigurationOfASN1';
						repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ].
			spec
				project: 'ASN1-Tool' copyFrom: 'ASN1' with: [
					spec loads:  #( 'ASN1-Tool' ) ].
			spec
				project: 'ASN1-Tests-Builder' copyFrom: 'ASN1' with: [
					spec loads:  #( 'ASN1-Tests-Builder' ) ].
			spec
				project: 'ASN1 full' copyFrom: 'ASN1' with: [
					spec loads:  #( 'tests' ) ].
			spec
				project: 'ASN1-Tests-Tool' copyFrom: 'ASN1-Tool' with: [
					spec loads:  #( 'ASN1-Tests-Tool' ) ].
			
                spec
				group: 'default' with: #('ASN1-Tool' 'Osmocom' 'ROS-Core' 'MAP-Core' 'TCAP-Core');
				group: 'q787' with: #( 'Q787-TestSpec' );
				group: 'all' with: #('default' 'ASN1 full')].
]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> baseline2: spec [ 
        <version: '2-baseline'>

	spec for: #common do: [
		spec blessing: #baseline.
                spec repository: 'http://smalltalkhub.com/mc/osmocom/Osmocom/main'.    
                spec 
				package: 'TCAP-Core' with: [ spec requires: #('ASN1-Tool' 'ASN1-Tests-Builder' 'MAP-Core' 'ASN1-Tests-Tool' 'Phexample')];
				package: 'MAP-Core' with: [ spec requires: #('ROS-Core' )];
				package: 'ROS-Core' with: [ spec requires: #('ASN1-Tool') ];
				package: 'Q787-TestSpec' with: [ spec requires: #('TCAP-Core') ];
				package: 'SS7-Helper' with: [ spec requires: #('Osmocom') ].
			spec
				project: 'Phexample' with: [
					spec
						className: 'ConfigurationOfPhexample';
						versionString: '1.2';
						repository: 'http://smalltalkhub.com/mc/Phexample/Phexample/main' ].	
			spec
				project: 'Osmocom' with: [
					spec
						className: 'ConfigurationOfOsmocom';
						versionString: #'bleedingEdge';
						file: 'ConfigurationOfOsmocom';
						repository: 'http://smalltalkhub.com/mc/osmocom/Osmocom/main' ].
			spec
				project: 'ASN1' with: [
					spec
						className: 'ConfigurationOfASN1';
						versionString: #bleedingEdge;
						file: 'ConfigurationOfASN1';
						repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ].
			spec
				project: 'ASN1-Tool' copyFrom: 'ASN1' with: [
					spec loads:  #( 'ASN1-Tool' ) ].
			spec
				project: 'ASN1-Tests-Builder' copyFrom: 'ASN1' with: [
					spec loads:  #( 'ASN1-Tests-Builder' ) ].
			spec
				project: 'ASN1 full' copyFrom: 'ASN1' with: [
					spec loads:  #( 'tests' ) ].
			spec
				project: 'ASN1-Tests-Tool' copyFrom: 'ASN1-Tool' with: [
					spec loads:  #( 'ASN1-Tests-Tool' ) ].
			
			
                spec
				group: 'default' with: #('ASN1-Tool' 'Osmocom' 'ROS-Core' 'MAP-Core' 'TCAP-Core' 'SS7-Helper');
				group: 'q787' with: #( 'Q787-TestSpec' );
				group: 'all' with: #('default' 'ASN1 full' 'q787')].
]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> baseline3: spec [ 
        <version: '3-baseline'>

	spec for: #common do: [
		spec blessing: #baseline.
                spec repository: 'http://smalltalkhub.com/mc/osmocom/Osmocom/main'.    
                spec 
				package: 'TCAP-Core' with: [ spec requires: #('ASN1-Tool' 'ASN1-Tests-Builder' 'MAP-Core' 'ASN1-Tests-Tool' 'Phexample')];
				package: 'MAP-Core' with: [ spec requires: #('ROS-Core' )];
				package: 'ROS-Core' with: [ spec requires: #('ASN1-Tool' 'ASN1-Builder') ];
				package: 'Q787-TestSpec' with: [ spec requires: #('TCAP-Core') ];
				package: 'SS7-Helper' with: [ spec requires: #('Osmocom') ].
			spec
				project: 'Phexample' with: [
					spec
						className: 'ConfigurationOfPhexample';
						versionString: '1.2';
						repository: 'http://smalltalkhub.com/mc/Phexample/Phexample/main' ].	
			spec
				project: 'Osmocom' with: [
					spec
						className: 'ConfigurationOfOsmocom';
						versionString: #'bleedingEdge';
						file: 'ConfigurationOfOsmocom';
						repository: 'http://smalltalkhub.com/mc/osmocom/Osmocom/main' ].
			spec
				project: 'ASN1' with: [
					spec
						className: 'ConfigurationOfASN1';
						versionString: #bleedingEdge;
						file: 'ConfigurationOfASN1';
						repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ].
			spec
				project: 'ASN1-Tool' copyFrom: 'ASN1' with: [
					spec loads:  #( 'ASN1-Tool' ) ].
			spec
				project: 'ASN1-Builder' copyFrom: 'ASN1' with: [
					spec loads:  #( 'ASN1-Builder' ) ].
			spec
				project: 'ASN1-Tests-Builder' copyFrom: 'ASN1' with: [
					spec loads:  #( 'ASN1-Tests-Builder' ) ].
			spec
				project: 'ASN1 full' copyFrom: 'ASN1' with: [
					spec loads:  #( 'tests' ) ].
			spec
				project: 'ASN1-Tests-Tool' copyFrom: 'ASN1-Tool' with: [
					spec loads:  #( 'ASN1-Tests-Tool' ) ].
			
			
                spec
				group: 'default' with: #('ASN1-Tool' 'Osmocom' 'ROS-Core' 'MAP-Core' 'TCAP-Core' 'SS7-Helper');
				group: 'q787' with: #( 'Q787-TestSpec' );
				group: 'all' with: #('default' 'ASN1 full' 'q787')].
]

{ #category : #baselines }
ConfigurationOfTCAP >> baseline4: spec [
	<version: '4-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/osmocom/Osmocom/main'.
		spec 
			project: 'Phexample' with: [
				spec
					className: #ConfigurationOfPhexample;
					versionString: '1.2';
					repository: 'http://smalltalkhub.com/mc/Phexample/Phexample/main' ];
			project: 'Osmocom' with: [
				spec
					className: #ConfigurationOfOsmocom;
					versionString: #'bleedingEdge';
					repository: 'http://smalltalkhub.com/mc/osmocom/Osmocom/main' ];
			project: 'ASN1' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'bleedingEdge';
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tool' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'bleedingEdge';
					loads: #('ASN1-Tool' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Builder' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'bleedingEdge';
					loads: #('ASN1-Builder' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tests-Builder' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'bleedingEdge';
					loads: #('ASN1-Tests-Builder' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1 full' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'bleedingEdge';
					loads: #('tests' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tests-Tool' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'bleedingEdge';
					loads: #('ASN1-Tests-Tool' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ].
		spec 
			package: 'SS7-Helper' with: [
				spec requires: #('Osmocom' ). ];
			package: 'ROS-Core' with: [
				spec requires: #('ASN1-Tool' 'ASN1-Builder' ). ];
			package: 'MAP-Core' with: [
				spec requires: #('ROS-Core' ). ];
			package: 'TCAP-Core' with: [
				spec requires: #('ASN1-Tool' 'ASN1-Tests-Builder' 'MAP-Core' 'ASN1-Tests-Tool' 'Phexample' ). ];
			package: 'Q787-TestSpec' with: [
				spec requires: #('TCAP-Core' ). ].
		spec 
			group: 'default' with: #('ASN1-Tool' 'Osmocom' 'ROS-Core' 'MAP-Core' 'TCAP-Core' 'SS7-Helper' );
			group: 'q787' with: #( 'Q787-TestSpec' );
			group: 'all' with: #('default' 'ASN1 full' ). ].

]

{ #category : #baselines }
ConfigurationOfTCAP >> baseline5: spec [
	<version: '5-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/osmocom/TCAP/main'.
		spec 
			project: 'Phexample' with: [
				spec
					className: #ConfigurationOfPhexample;
					versionString: '1.2';
					repository: 'http://smalltalkhub.com/mc/Phexample/Phexample/main' ];
			project: 'ASN1' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'bleedingEdge';
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tool' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'bleedingEdge';
					loads: #('ASN1-Tool' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Builder' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'bleedingEdge';
					loads: #('ASN1-Builder' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tests-Builder' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'bleedingEdge';
					loads: #('ASN1-Tests-Builder' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1 full' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'bleedingEdge';
					loads: #('tests' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tests-Tool' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'bleedingEdge';
					loads: #('ASN1-Tests-Tool' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'OsmoCore' with: [
				spec
					className: #ConfigurationOfOsmoCore;
					versionString: #'bleedingEdge';
					repository: 'http://smalltalkhub.com/mc/osmocom/Core/main/' ];
			project: 'OsmoNetwork' with: [
				spec
					className: #ConfigurationOfOsmoNetwork;
					versionString: #'bleedingEdge';
					repository: 'http://smalltalkhub.com/mc/osmocom/Network/main/' ].
		spec 
			package: 'ROS-Core' with: [
				spec requires: #('ASN1-Tool' 'ASN1-Builder' ). ];
			package: 'MAP-Core' with: [
				spec requires: #('ROS-Core' ). ];
			package: 'TCAP-Core' with: [
				spec requires: #('ASN1-Tool' 'ASN1-Tests-Builder' 'MAP-Core' 'ASN1-Tests-Tool' 'Phexample' 'OsmoCore' ). ];
			package: 'Q787-TestSpec' with: [
				spec requires: #('TCAP-Core' 'OsmoNetwork' ). ];
			package: 'TCAP-Benchmark'.
		spec 
			group: 'default' with: #('ASN1-Tool' 'ROS-Core' 'MAP-Core' 'TCAP-Core' );
			group: 'q787' with: #('Q787-TestSpec' );
			group: 'all' with: #('default' 'ASN1 full' );
			group: 'bench' with: #('default' 'TCAP-Benchmark' ). ].

]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'common' version: '5-baseline'.

]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> project [

	^ project ifNil: [ | projectAttributes |
		"Bootstrap Metacello if it is not already loaded"
		self class ensureMetacello.
		"Construct Metacello project"
		project := (Smalltalk at: #MetacelloMCProject) new.
		projectAttributes := #().
		Smalltalk at: #SystemVersion ifPresent: [:cl | | versionString |
			versionString := cl current version.
			((versionString beginsWith: 'Pharo-1.0') or: [versionString beginsWith: 'PharoCore1.0'])
				ifTrue: [ projectAttributes := projectAttributes, #(#'GreaseForPharo1.0') ] ].
		project projectAttributes:  projectAttributes.
		(Smalltalk at: #MetacelloVersionConstructor) on: self project: project.
		project loadType: #linear ]
]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> stable: spec [
	<symbolicVersion: #'stable'>

	spec for: #'common' version: '0.3'.

]

{ #category : #versions }
ConfigurationOfTCAP >> version01: spec [
	<version: '0.1' imports: #('0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: '0.3.8 : version bump
0.3.9 : version bump
0.1 : bisecting SS7 into TCAP and HLR'.
		spec author: 'NorbertHartl'.
		spec timestamp: '12/10/2013 11:56'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'Osmocom' with: '0.1.6';
			project: 'ASN1' with: '0.8.6';
			project: 'ASN1-Tool' with: '0.8.6';
			project: 'ASN1-Tests-Builder' with: '0.8.6';
			project: 'ASN1 full' with: '0.8.6';
			project: 'ASN1-Tests-Tool' with: '0.8.6'.
		spec 
			package: 'TCAP-Core' with: 'TCAP-Core-HolgerHansPeterFreyther.103';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.14';
			package: 'ROS-Core' with: 'ROS-Core-NorbertHartl.20';
			package: 'HLR-Core' with: 'HLR-Core-HolgerHansPeterFreyther.81';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-NorbertHartl.25'. ].

]

{ #category : #versions }
ConfigurationOfTCAP >> version021: spec [
	<version: '0.2.1' imports: #('0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'release'.
		spec description: '0.2 : fixed Issue #1086 : dialogue portions should only be sent in initiation received state and only for continue and end. Fix and tests added'.
		spec author: 'NorbertHartl'.
		spec timestamp: '1/14/2014 15:02'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'Osmocom' with: '0.1.6';
			project: 'ASN1' with: '0.8.14';
			project: 'ASN1-Tool' with: '0.8.14';
			project: 'ASN1-Tests-Builder' with: '0.8.14';
			project: 'ASN1 full' with: '0.8.14';
			project: 'ASN1-Tests-Tool' with: '0.8.14'.
		spec 
			package: 'TCAP-Core' with: 'TCAP-Core-NorbertHartl.105';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.14';
			package: 'ROS-Core' with: 'ROS-Core-NorbertHartl.20';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-NorbertHartl.26'. ].

]

{ #category : #versions }
ConfigurationOfTCAP >> version02: spec [
	<version: '0.2' imports: #('0.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'development'.
		spec description: '0.1 : bisecting SS7 into TCAP and HLR
0.2 : fixed Issue #1086 : dialogue portions should only be sent in initiation received state and only for continue and end. Fix and tests added'.
		spec author: 'NorbertHartl'.
		spec timestamp: '1/14/2014 15:02'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'Osmocom' with: '0.1.6';
			project: 'ASN1' with: '0.8.13';
			project: 'ASN1-Tool' with: '0.8.13';
			project: 'ASN1-Tests-Builder' with: '0.8.13';
			project: 'ASN1 full' with: '0.8.13';
			project: 'ASN1-Tests-Tool' with: '0.8.13'.
		spec 
			package: 'TCAP-Core' with: 'TCAP-Core-NorbertHartl.105';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.14';
			package: 'ROS-Core' with: 'ROS-Core-NorbertHartl.20';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-NorbertHartl.26'. ].

]

{ #category : #versions }
ConfigurationOfTCAP >> version03: spec [
	<version: '0.3' imports: #('4-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 0.3'.
		spec author: 'NorbertHartl'.
		spec timestamp: '1/16/2015 14:07'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'Osmocom' with: '2-baseline';
			project: 'ASN1' with: '0.8.27-baseline';
			project: 'ASN1-Tool' with: '0.8.27-baseline';
			project: 'ASN1-Builder' with: '0.8.27-baseline';
			project: 'ASN1-Tests-Builder' with: '0.8.27-baseline';
			project: 'ASN1 full' with: '0.8.27-baseline';
			project: 'ASN1-Tests-Tool' with: '0.8.27-baseline'.
		spec 
			package: 'SS7-Helper' with: 'SS7-Helper-NorbertHartl.2';
			package: 'ROS-Core' with: 'ROS-Core-NorbertHartl.39';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.36';
			package: 'TCAP-Core' with: 'TCAP-Core-NorbertHartl.182';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-NorbertHartl.45'. ].

]
