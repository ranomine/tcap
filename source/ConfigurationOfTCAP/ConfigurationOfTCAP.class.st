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

{ #category : #baselines }
ConfigurationOfTCAP >> baseline010: spec [
	<version: '0.10-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/osmocom/TCAP/main'.
		spec 
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
			project: 'Fuel' with: [
				spec
					className: #ConfigurationOfFuel;
					versionString: '1.9.4';
					repository: 'http://smalltalkhub.com/mc/Pharo/Fuel/main/' ];
			project: 'OsmoCore' with: [
				spec
					className: #ConfigurationOfOsmoCore;
					versionString: #'bleedingEdge';
					repository: 'http://smalltalkhub.com/mc/osmocom/Core/main/' ];
			project: 'OsmoNetwork' with: [
				spec
					className: #ConfigurationOfOsmoNetwork;
					versionString: #'bleedingEdge';
					repository: 'http://smalltalkhub.com/mc/osmocom/Network/main/' ];
			project: 'Phexample' with: [
				spec
					className: #ConfigurationOfPhexample;
					versionString: '1.2';
					repository: 'http://smalltalkhub.com/mc/Phexample/Phexample/main' ].
		spec 
			package: 'Camel-Core';
			package: 'Camel-SCF';
			package: 'MAP-Core' with: [
				spec requires: #('ROS-Core' 'STON-Core' ). ];
			package: 'Q787-TestSpec' with: [
				spec requires: #('TCAP-Core' 'OsmoNetwork' ). ];
			package: 'ROS-Core' with: [
				spec requires: #('ASN1-Tool' 'ASN1-Builder' ). ];
			package: 'STON-Core';
			package: 'TCAP-Benchmark';
			package: 'TCAP-Core' with: [
				spec requires: #('ASN1-Tool' 'ASN1-Tests-Builder' 'MAP-Core' 'ASN1-Tests-Tool' 'Phexample' 'OsmoCore' 'OsmoNetwork' 'Fuel' ). ].
		spec 
			group: 'all' with: #('default' 'ASN1 full' 'tests' 'camel' );
			group: 'bench' with: #('default' 'TCAP-Benchmark' );
			group: 'camel' with: #('default' 'Camel-Core' 'Camel-SCF' );
			group: 'default' with: #('ASN1-Tool' 'ROS-Core' 'MAP-Core' 'TCAP-Core' );
			group: 'q787' with: #('Q787-TestSpec' );
			group: 'tests' with: #('Q787-TestSpec' ). ].

]

{ #category : #baselines }
ConfigurationOfTCAP >> baseline06: spec [
	<version: '0.6-baseline'>

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
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tool' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('ASN1-Tool' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Builder' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('ASN1-Builder' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tests-Builder' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('ASN1-Tests-Builder' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1 full' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('tests' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tests-Tool' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('ASN1-Tests-Tool' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'OsmoCore' with: [
				spec
					className: #ConfigurationOfOsmoCore;
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/osmocom/Core/main/' ];
			project: 'OsmoNetwork' with: [
				spec
					className: #ConfigurationOfOsmoNetwork;
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/osmocom/Network/main/' ];
			project: 'Fuel' with: [
				spec
					className: #ConfigurationOfFuel;
					versionString: '1.9.4';
					repository: 'http://smalltalkhub.com/mc/Pharo/Fuel/main/' ].
		spec 
			package: 'ROS-Core' with: [
				spec requires: #('ASN1-Tool' 'ASN1-Builder' ). ];
			package: 'TCAP-Benchmark';
			package: 'STON-Core';
			package: 'MAP-Core' with: [
				spec requires: #('ROS-Core' 'STON-Core' ). ];
			package: 'TCAP-Core' with: [
				spec requires: #('ASN1-Tool' 'ASN1-Tests-Builder' 'MAP-Core' 'ASN1-Tests-Tool' 'Phexample' 'OsmoCore' 'OsmoNetwork' 'Fuel' ). ];
			package: 'Q787-TestSpec' with: [
				spec requires: #('TCAP-Core' 'OsmoNetwork' ). ];
			package: 'Camel-Core';
			package: 'Camel-SCF'.
		spec 
			group: 'default' with: #('ASN1-Tool' 'ROS-Core' 'MAP-Core' 'TCAP-Core' );
			group: 'q787' with: #('Q787-TestSpec' );
			group: 'all' with: #('default' 'ASN1 full' 'tests' 'camel' );
			group: 'bench' with: #('default' 'TCAP-Benchmark' );
			group: 'tests' with: #('Q787-TestSpec' );
			group: 'camel' with: #('default' 'Camel-Core' 'Camel-SCF' ). ].

]

{ #category : #baselines }
ConfigurationOfTCAP >> baseline071: spec [
	<version: '0.7.1-baseline'>

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
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tool' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('ASN1-Tool' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Builder' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('ASN1-Builder' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tests-Builder' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('ASN1-Tests-Builder' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1 full' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('tests' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tests-Tool' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('ASN1-Tests-Tool' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'OsmoCore' with: [
				spec
					className: #ConfigurationOfOsmoCore;
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/osmocom/Core/main/' ];
			project: 'OsmoNetwork' with: [
				spec
					className: #ConfigurationOfOsmoNetwork;
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/osmocom/Network/main/' ];
			project: 'Fuel' with: [
				spec
					className: #ConfigurationOfFuel;
					versionString: '1.9.4';
					repository: 'http://smalltalkhub.com/mc/Pharo/Fuel/main/' ].
		spec 
			package: 'ROS-Core' with: [
				spec requires: #('ASN1-Tool' 'ASN1-Builder' ). ];
			package: 'TCAP-Benchmark';
			package: 'MAP-Core';
			package: 'TCAP-Core' with: [
				spec requires: #('ASN1-Tool' 'ASN1-Tests-Builder' 'MAP-Core' 'ASN1-Tests-Tool' 'Phexample' 'OsmoCore' 'OsmoNetwork' 'Fuel' ). ];
			package: 'Q787-TestSpec' with: [
				spec requires: #('TCAP-Core' 'OsmoNetwork' ). ];
			package: 'Camel-Core';
			package: 'Camel-SCF'.
		spec 
			group: 'default' with: #('ASN1-Tool' 'ROS-Core' 'MAP-Core' 'TCAP-Core' );
			group: 'q787' with: #('Q787-TestSpec' );
			group: 'all' with: #('default' 'ASN1 full' 'tests' 'camel' );
			group: 'bench' with: #('default' 'TCAP-Benchmark' );
			group: 'tests' with: #('Q787-TestSpec' );
			group: 'camel' with: #('default' 'Camel-Core' 'Camel-SCF' ). ].

]

{ #category : #baselines }
ConfigurationOfTCAP >> baseline07: spec [
	<version: '0.7-baseline'>

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
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tool' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('ASN1-Tool' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Builder' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('ASN1-Builder' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tests-Builder' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('ASN1-Tests-Builder' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1 full' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('tests' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tests-Tool' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('ASN1-Tests-Tool' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'OsmoCore' with: [
				spec
					className: #ConfigurationOfOsmoCore;
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/osmocom/Core/main/' ];
			project: 'OsmoNetwork' with: [
				spec
					className: #ConfigurationOfOsmoNetwork;
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/osmocom/Network/main/' ];
			project: 'Fuel' with: [
				spec
					className: #ConfigurationOfFuel;
					versionString: '1.9.4';
					repository: 'http://smalltalkhub.com/mc/Pharo/Fuel/main/' ].
		spec 
			package: 'ROS-Core' with: [
				spec requires: #('ASN1-Tool' 'ASN1-Builder' ). ];
			package: 'TCAP-Benchmark';
			package: 'STON-Core';
			package: 'MAP-Core' with: [
				spec requires: #('ROS-Core' 'STON-Core' ). ];
			package: 'TCAP-Core' with: [
				spec requires: #('ASN1-Tool' 'ASN1-Tests-Builder' 'MAP-Core' 'ASN1-Tests-Tool' 'Phexample' 'OsmoCore' 'OsmoNetwork' 'Fuel' ). ];
			package: 'Q787-TestSpec' with: [
				spec requires: #('TCAP-Core' 'OsmoNetwork' ). ];
			package: 'Camel-Core';
			package: 'Camel-SCF'.
		spec 
			group: 'default' with: #('ASN1-Tool' 'ROS-Core' 'MAP-Core' 'TCAP-Core' );
			group: 'q787' with: #('Q787-TestSpec' );
			group: 'all' with: #('default' 'ASN1 full' 'tests' 'camel' );
			group: 'bench' with: #('default' 'TCAP-Benchmark' );
			group: 'tests' with: #('Q787-TestSpec' );
			group: 'camel' with: #('default' 'Camel-Core' 'Camel-SCF' ). ].

]

{ #category : #baselines }
ConfigurationOfTCAP >> baseline08: spec [
	<version: '0.8-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/osmocom/TCAP/main'.
		spec 
			project: 'ASN1' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: '1';
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tool' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: '1';
					loads: #('ASN1-Tool' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Builder' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: '1';
					loads: #('ASN1-Builder' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tests-Builder' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: '1';
					loads: #('ASN1-Tests-Builder' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1 full' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: '1';
					loads: #('tests' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tests-Tool' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: '1';
					loads: #('ASN1-Tests-Tool' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'Fuel' with: [
				spec
					className: #ConfigurationOfFuel;
					versionString: '1.9.4';
					repository: 'http://smalltalkhub.com/mc/Pharo/Fuel/main/' ];
			project: 'OsmoCore' with: [
				spec
					className: #ConfigurationOfOsmoCore;
					versionString: '1';
					repository: 'http://smalltalkhub.com/mc/osmocom/Core/main/' ];
			project: 'OsmoNetwork' with: [
				spec
					className: #ConfigurationOfOsmoNetwork;
					versionString: '3';
					repository: 'http://smalltalkhub.com/mc/osmocom/Network/main/' ];
			project: 'Phexample' with: [
				spec
					className: #ConfigurationOfPhexample;
					versionString: '1.2';
					repository: 'http://smalltalkhub.com/mc/Phexample/Phexample/main' ].
		spec 
			package: 'Camel-Core';
			package: 'Camel-SCF';
			package: 'MAP-Core' with: [
				spec requires: #('ROS-Core' 'STON-Core' ). ];
			package: 'Q787-TestSpec' with: [
				spec requires: #('TCAP-Core' 'OsmoNetwork' ). ];
			package: 'ROS-Core' with: [
				spec requires: #('ASN1-Tool' 'ASN1-Builder' ). ];
			package: 'STON-Core';
			package: 'TCAP-Benchmark';
			package: 'TCAP-Core' with: [
				spec requires: #('ASN1-Tool' 'ASN1-Tests-Builder' 'MAP-Core' 'ASN1-Tests-Tool' 'Phexample' 'OsmoCore' 'OsmoNetwork' 'Fuel' ). ].
		spec 
			group: 'all' with: #('default' 'ASN1 full' 'tests' 'camel' );
			group: 'bench' with: #('default' 'TCAP-Benchmark' );
			group: 'camel' with: #('default' 'Camel-Core' 'Camel-SCF' );
			group: 'default' with: #('ASN1-Tool' 'ROS-Core' 'MAP-Core' 'TCAP-Core' );
			group: 'q787' with: #('Q787-TestSpec' );
			group: 'tests' with: #('Q787-TestSpec' ). ].

]

{ #category : #baselines }
ConfigurationOfTCAP >> baseline09: spec [
	<version: '0.9-baseline'>

	spec for: #'common' do: [
		spec blessing: #'baseline'.
		spec repository: 'http://smalltalkhub.com/mc/osmocom/TCAP/main'.
		spec 
			project: 'ASN1' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: '1';
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tool' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: '1';
					loads: #('ASN1-Tool' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Builder' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: '1';
					loads: #('ASN1-Builder' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tests-Builder' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: '1';
					loads: #('ASN1-Tests-Builder' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1 full' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: '1';
					loads: #('tests' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tests-Tool' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: '1';
					loads: #('ASN1-Tests-Tool' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'Fuel' with: [
				spec
					className: #ConfigurationOfFuel;
					versionString: '1.9.4';
					repository: 'http://smalltalkhub.com/mc/Pharo/Fuel/main/' ];
			project: 'OsmoCore' with: [
				spec
					className: #ConfigurationOfOsmoCore;
					versionString: '1';
					repository: 'http://smalltalkhub.com/mc/osmocom/Core/main/' ];
			project: 'OsmoNetwork' with: [
				spec
					className: #ConfigurationOfOsmoNetwork;
					versionString: '3';
					repository: 'http://smalltalkhub.com/mc/osmocom/Network/main/' ];
			project: 'Phexample' with: [
				spec
					className: #ConfigurationOfPhexample;
					versionString: '1.2';
					repository: 'http://smalltalkhub.com/mc/Phexample/Phexample/main' ].
		spec 
			package: 'Camel-Core';
			package: 'Camel-SCF';
			package: 'MAP-Core' with: [
				spec requires: #('ROS-Core' 'STON-Core' ). ];
			package: 'Q787-TestSpec' with: [
				spec requires: #('TCAP-Core' 'OsmoNetwork' ). ];
			package: 'ROS-Core' with: [
				spec requires: #('ASN1-Tool' 'ASN1-Builder' ). ];
			package: 'STON-Core';
			package: 'TCAP-Benchmark';
			package: 'TCAP-Core' with: [
				spec requires: #('ASN1-Tool' 'ASN1-Tests-Builder' 'MAP-Core' 'ASN1-Tests-Tool' 'Phexample' 'OsmoCore' 'OsmoNetwork' 'Fuel' ). ].
		spec 
			group: 'all' with: #('default' 'ASN1 full' 'tests' 'camel' );
			group: 'bench' with: #('default' 'TCAP-Benchmark' );
			group: 'camel' with: #('default' 'Camel-Core' 'Camel-SCF' );
			group: 'default' with: #('ASN1-Tool' 'ROS-Core' 'MAP-Core' 'TCAP-Core' );
			group: 'q787' with: #('Q787-TestSpec' );
			group: 'tests' with: #('Q787-TestSpec' ). ].

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
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tool' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('ASN1-Tool' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Builder' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('ASN1-Builder' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tests-Builder' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('ASN1-Tests-Builder' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1 full' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('tests' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'ASN1-Tests-Tool' with: [
				spec
					className: #ConfigurationOfASN1;
					versionString: #'stable';
					loads: #('ASN1-Tests-Tool' );
					repository: 'http://smalltalkhub.com/mc/NorbertHartl/ASN1/main' ];
			project: 'OsmoCore' with: [
				spec
					className: #ConfigurationOfOsmoCore;
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/osmocom/Core/main/' ];
			project: 'OsmoNetwork' with: [
				spec
					className: #ConfigurationOfOsmoNetwork;
					versionString: #'stable';
					repository: 'http://smalltalkhub.com/mc/osmocom/Network/main/' ];
			project: 'Fuel' with: [
				spec
					className: #ConfigurationOfFuel;
					versionString: '1.9.4';
					repository: 'http://smalltalkhub.com/mc/Pharo/Fuel/main/' ].
		spec 
			package: 'ROS-Core' with: [
				spec requires: #('ASN1-Tool' 'ASN1-Builder' ). ];
			package: 'MAP-Core' with: [
				spec requires: #('ROS-Core' 'STON-Core'). ];
			package: 'TCAP-Core' with: [
				spec requires: #('ASN1-Tool' 'ASN1-Tests-Builder' 'MAP-Core' 'ASN1-Tests-Tool' 'Phexample' 'OsmoCore' 'OsmoNetwork' 'Fuel' ). ];
			package: 'Q787-TestSpec' with: [
				spec requires: #('TCAP-Core' 'OsmoNetwork' ). ];
			package: 'TCAP-Benchmark';
			package: 'STON-Core';
			package: 'Camel-Core';
			package: 'Camel-SCF'.
		spec 
			group: 'default' with: #('ASN1-Tool' 'ROS-Core' 'MAP-Core' 'TCAP-Core' );
			group: 'q787' with: #('Q787-TestSpec' );
			group: 'all' with: #('default' 'ASN1 full' 'tests' 'camel' );
			group: 'bench' with: #('default' 'TCAP-Benchmark' );
			group: 'tests' with: #('Q787-TestSpec' );
			group: 'camel' with: #('default' 'Camel-Core' 'Camel-SCF' ). ].

]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> development: spec [
	<symbolicVersion: #'development'>

	spec for: #'common' version: '0.10-baseline'.

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

	spec for: #'common' version: '9'.

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

{ #category : #versions }
ConfigurationOfTCAP >> version04: spec [
	<version: '0.4' imports: #('5-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 0.4'.
		spec author: 'NorbertHartl'.
		spec timestamp: '9/9/2015 14:42'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'ASN1' with: '0.8.28-baseline';
			project: 'ASN1-Tool' with: '0.8.28-baseline';
			project: 'ASN1-Builder' with: '0.8.28-baseline';
			project: 'ASN1-Tests-Builder' with: '0.8.28-baseline';
			project: 'ASN1 full' with: '0.8.28-baseline';
			project: 'ASN1-Tests-Tool' with: '0.8.28-baseline';
			project: 'OsmoCore' with: '0.1-baseline';
			project: 'OsmoNetwork' with: '0.1-baseline';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-NorbertHartl.49';
			package: 'MAP-Core' with: 'MAP-Core-NorbertHartl.60';
			package: 'TCAP-Core' with: 'TCAP-Core-NorbertHartl.232';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-NorbertHartl.70';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'STON-Core' with: 'STON-Core-NorbertHartl.64';
			package: 'Camel-Core' with: 'Camel-Core-NorbertHartl.10';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.6'. ].

]

{ #category : #versions }
ConfigurationOfTCAP >> version10: spec [
	<version: '10' imports: #('0.9-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 10'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '04/29/2018 13:12'.
		spec
			project: 'Phexample' with: '3.2';
			project: 'ASN1' with: '1.2';
			project: 'ASN1-Tool' with: '1.2';
			project: 'ASN1-Builder' with: '1.2';
			project: 'ASN1-Tests-Builder' with: '1.2';
			project: 'ASN1 full' with: '1.2';
			project: 'ASN1-Tests-Tool' with: '1.2';
			project: 'OsmoCore' with: '6';
			project: 'OsmoNetwork' with: '6';
			project: 'Fuel' with: '1.9.4'.

		spec
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.78';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'STON-Core' with: 'STON-Core-NorbertHartl.64';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.81';
			package: 'TCAP-Core' with: 'TCAP-Core-HolgerHansPeterFreyther.312';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.155';
			package: 'Camel-Core' with: 'Camel-Core-HolgerHansPeterFreyther.14';
			package: 'Camel-SCF' with: 'Camel-SCF-HolgerHansPeterFreyther.9'. ].

]

{ #category : #versions }
ConfigurationOfTCAP >> version5: spec [
	<version: '5' imports: #('5-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 5'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '2/9/2016 19:14'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'ASN1' with: '1';
			project: 'ASN1-Tool' with: '1';
			project: 'ASN1-Builder' with: '1';
			project: 'ASN1-Tests-Builder' with: '1';
			project: 'ASN1 full' with: '1';
			project: 'ASN1-Tests-Tool' with: '1';
			project: 'OsmoCore' with: '1';
			project: 'OsmoNetwork' with: '1';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.64';
			package: 'MAP-Core' with: 'MAP-Core-NorbertHartl.71';
			package: 'TCAP-Core' with: 'TCAP-Core-MarcusDenker.271';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.119';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'Camel-Core' with: 'Camel-Core-NorbertHartl.10';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8';
			package: 'STON-Core'with: 'STON-Core-NorbertHartl.64' ].

]

{ #category : #versions }
ConfigurationOfTCAP >> version6: spec [
	<version: '6' imports: #('0.6-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 6'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '2/13/2016 23:06'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'ASN1' with: '1';
			project: 'ASN1-Tool' with: '1';
			project: 'ASN1-Builder' with: '1';
			project: 'ASN1-Tests-Builder' with: '1';
			project: 'ASN1 full' with: '1';
			project: 'ASN1-Tests-Tool' with: '1';
			project: 'OsmoCore' with: '1';
			project: 'OsmoNetwork' with: '2';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.64';
			package: 'MAP-Core' with: 'MAP-Core-NorbertHartl.71';
			package: 'TCAP-Core' with: 'TCAP-Core-MarcusDenker.271';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.119';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'Camel-Core' with: 'Camel-Core-NorbertHartl.10';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8';
			package: 'STON-Core'with: 'STON-Core-NorbertHartl.64' ].
]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> version710: spec [
	<version: '7.10' imports: #('0.7-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 7.10'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '03/14/2017 20:13'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'ASN1' with: '1.1';
			project: 'ASN1-Tool' with: '1.1';
			project: 'ASN1-Builder' with: '1.1';
			project: 'ASN1-Tests-Builder' with: '1.1';
			project: 'ASN1 full' with: '1.1';
			project: 'ASN1-Tests-Tool' with: '1.1';
			project: 'OsmoCore' with: '2';
			project: 'OsmoNetwork' with: '4';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.64';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'STON-Core' with: 'STON-Core-NorbertHartl.64';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.81';
			package: 'TCAP-Core' with: 'TCAP-Core-MarcusDenker.271';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.119';
			package: 'Camel-Core' with: 'Camel-Core-HolgerHansPeterFreyther.13';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8'. ].
]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> version711: spec [
	<version: '7.11' imports: #('0.7-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 7.11'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '05/02/2017 23:18'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'ASN1' with: '1.1';
			project: 'ASN1-Tool' with: '1.1';
			project: 'ASN1-Builder' with: '1.1';
			project: 'ASN1-Tests-Builder' with: '1.1';
			project: 'ASN1 full' with: '1.1';
			project: 'ASN1-Tests-Tool' with: '1.1';
			project: 'OsmoCore' with: '2';
			project: 'OsmoNetwork' with: '4';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.64';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'STON-Core' with: 'STON-Core-NorbertHartl.64';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.81';
			package: 'TCAP-Core' with: 'TCAP-Core-MarcusDenker.271';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.119';
			package: 'Camel-Core' with: 'Camel-Core-HolgerHansPeterFreyther.14';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8'. ].
]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> version712: spec [
	<version: '7.12' imports: #('0.7-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 7.12'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '06/05/2017 18:28'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'ASN1' with: '1.1';
			project: 'ASN1-Tool' with: '1.1';
			project: 'ASN1-Builder' with: '1.1';
			project: 'ASN1-Tests-Builder' with: '1.1';
			project: 'ASN1 full' with: '1.1';
			project: 'ASN1-Tests-Tool' with: '1.1';
			project: 'OsmoCore' with: '4';
			project: 'OsmoNetwork' with: '6';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.64';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'STON-Core' with: 'STON-Core-NorbertHartl.64';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.81';
			package: 'TCAP-Core' with: 'TCAP-Core-MarcusDenker.271';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.119';
			package: 'Camel-Core' with: 'Camel-Core-HolgerHansPeterFreyther.14';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8'. ].
]

{ #category : #versions }
ConfigurationOfTCAP >> version713: spec [
	<version: '7.13' imports: #('0.7-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 7.13'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '03/09/2019 15:51'.
		spec 
			project: 'Phexample' with: '3.2';
			project: 'ASN1' with: '1.2';
			project: 'ASN1-Tool' with: '1.2';
			project: 'ASN1-Builder' with: '1.2';
			project: 'ASN1-Tests-Builder' with: '1.2';
			project: 'ASN1 full' with: '1.2';
			project: 'ASN1-Tests-Tool' with: '1.2';
			project: 'OsmoCore' with: '4';
			project: 'OsmoNetwork' with: '6';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.64';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'STON-Core' with: 'STON-Core-NorbertHartl.64';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.81';
			package: 'TCAP-Core' with: 'TCAP-Core-MarcusDenker.271';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.119';
			package: 'Camel-Core' with: 'Camel-Core-HolgerHansPeterFreyther.14';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8'. ].
]

{ #category : #versions }
ConfigurationOfTCAP >> version714: spec [
	<version: '7.14' imports: #('0.7.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 7.14'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '03/06/2019 03:59'.
		spec 
			project: 'Phexample' with: '3.2';
			project: 'ASN1' with: '1.2';
			project: 'ASN1-Tool' with: '1.2';
			project: 'ASN1-Builder' with: '1.2';
			project: 'ASN1-Tests-Builder' with: '1.2';
			project: 'ASN1 full' with: '1.2';
			project: 'ASN1-Tests-Tool' with: '1.2';
			project: 'OsmoCore' with: '4';
			project: 'OsmoNetwork' with: '6';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.64';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.81';
			package: 'TCAP-Core' with: 'TCAP-Core-MarcusDenker.271';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.119';
			package: 'Camel-Core' with: 'Camel-Core-HolgerHansPeterFreyther.14';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8'. ].

	"Use our custom STON up to pharo6.x."
	spec for: #(#'pharo4.x' #'pharo5.x' #'pharo6.x') do: [
		spec package: 'STON-Core'.
		spec package: 'MAP-Core' with: [
				spec requires: #('ROS-Core' 'STON-Core' ). ].
		spec package: 'STON-Core' with: 'STON-Core-NorbertHartl.64'.
	]
]

{ #category : #versions }
ConfigurationOfTCAP >> version715: spec [
	<version: '7.15' imports: #('0.7.1-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 7.15'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '04/16/2019 06:15'.
		spec 
			project: 'Phexample' with: '3.2';
			project: 'ASN1' with: '1.3';
			project: 'ASN1-Tool' with: '1.3';
			project: 'ASN1-Builder' with: '1.3';
			project: 'ASN1-Tests-Builder' with: '1.3';
			project: 'ASN1 full' with: '1.3';
			project: 'ASN1-Tests-Tool' with: '1.3';
			project: 'OsmoCore' with: '6';
			project: 'OsmoNetwork' with: '7';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.64';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.81';
			package: 'TCAP-Core' with: 'TCAP-Core-MarcusDenker.271';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.119';
			package: 'Camel-Core' with: 'Camel-Core-HolgerHansPeterFreyther.14';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8'. ].

	"Use our custom STON up to pharo6.x."
	spec for: #(#'pharo4.x' #'pharo5.x' #'pharo6.x') do: [
		spec package: 'STON-Core'.
		spec package: 'MAP-Core' with: [
				spec requires: #('ROS-Core' 'STON-Core' ). ].
		spec package: 'STON-Core' with: 'STON-Core-NorbertHartl.64'.
	]
]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> version71: spec [
	<version: '7.1' imports: #('0.7-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 7'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '4/5/2016 05:32'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'ASN1' with: '1';
			project: 'ASN1-Tool' with: '1';
			project: 'ASN1-Builder' with: '1';
			project: 'ASN1-Tests-Builder' with: '1';
			project: 'ASN1 full' with: '1';
			project: 'ASN1-Tests-Tool' with: '1';
			project: 'OsmoCore' with: '1';
			project: 'OsmoNetwork' with: '3';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.64';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'STON-Core' with: 'STON-Core-NorbertHartl.64';
			package: 'MAP-Core' with: 'MAP-Core-NorbertHartl.71';
			package: 'TCAP-Core' with: 'TCAP-Core-MarcusDenker.271';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.119';
			package: 'Camel-Core' with: 'Camel-Core-HolgerHansPeterFreyther.11';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8'. ].
]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> version72: spec [
	<version: '7.2' imports: #('0.7-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 7'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '10/11/2016 14:35'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'ASN1' with: '1';
			project: 'ASN1-Tool' with: '1';
			project: 'ASN1-Builder' with: '1';
			project: 'ASN1-Tests-Builder' with: '1';
			project: 'ASN1 full' with: '1';
			project: 'ASN1-Tests-Tool' with: '1';
			project: 'OsmoCore' with: '1';
			project: 'OsmoNetwork' with: '3';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.64';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'STON-Core' with: 'STON-Core-NorbertHartl.64';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.72';
			package: 'TCAP-Core' with: 'TCAP-Core-MarcusDenker.271';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.119';
			package: 'Camel-Core' with: 'Camel-Core-HolgerHansPeterFreyther.11';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8'. ].
]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> version73: spec [
	<version: '7.3' imports: #('0.7-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 7'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '10/11/2016 14:35'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'ASN1' with: '1';
			project: 'ASN1-Tool' with: '1';
			project: 'ASN1-Builder' with: '1';
			project: 'ASN1-Tests-Builder' with: '1';
			project: 'ASN1 full' with: '1';
			project: 'ASN1-Tests-Tool' with: '1';
			project: 'OsmoCore' with: '1';
			project: 'OsmoNetwork' with: '3';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.64';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'STON-Core' with: 'STON-Core-NorbertHartl.64';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.73';
			package: 'TCAP-Core' with: 'TCAP-Core-MarcusDenker.271';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.119';
			package: 'Camel-Core' with: 'Camel-Core-HolgerHansPeterFreyther.11';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8'. ].
]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> version74: spec [
	<version: '7.4' imports: #('0.7-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 7'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '10/20/2016 12:36'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'ASN1' with: '1';
			project: 'ASN1-Tool' with: '1';
			project: 'ASN1-Builder' with: '1';
			project: 'ASN1-Tests-Builder' with: '1';
			project: 'ASN1 full' with: '1';
			project: 'ASN1-Tests-Tool' with: '1';
			project: 'OsmoCore' with: '1';
			project: 'OsmoNetwork' with: '3';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.64';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'STON-Core' with: 'STON-Core-NorbertHartl.64';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.75';
			package: 'TCAP-Core' with: 'TCAP-Core-MarcusDenker.271';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.119';
			package: 'Camel-Core' with: 'Camel-Core-HolgerHansPeterFreyther.11';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8'. ].
]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> version75: spec [
	<version: '7.5' imports: #('0.7-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 7'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '10/20/2016 12:36'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'ASN1' with: '1';
			project: 'ASN1-Tool' with: '1';
			project: 'ASN1-Builder' with: '1';
			project: 'ASN1-Tests-Builder' with: '1';
			project: 'ASN1 full' with: '1';
			project: 'ASN1-Tests-Tool' with: '1';
			project: 'OsmoCore' with: '2';
			project: 'OsmoNetwork' with: '4';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.64';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'STON-Core' with: 'STON-Core-NorbertHartl.64';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.75';
			package: 'TCAP-Core' with: 'TCAP-Core-MarcusDenker.271';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.119';
			package: 'Camel-Core' with: 'Camel-Core-HolgerHansPeterFreyther.11';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8'. ].
]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> version76: spec [
	<version: '7.6' imports: #('0.7-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 7.6'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '10/30/2016 15:06'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'ASN1' with: '1.1';
			project: 'ASN1-Tool' with: '1.1';
			project: 'ASN1-Builder' with: '1.1';
			project: 'ASN1-Tests-Builder' with: '1.1';
			project: 'ASN1 full' with: '1.1';
			project: 'ASN1-Tests-Tool' with: '1.1';
			project: 'OsmoCore' with: '2';
			project: 'OsmoNetwork' with: '4';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.64';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'STON-Core' with: 'STON-Core-NorbertHartl.64';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.75';
			package: 'TCAP-Core' with: 'TCAP-Core-MarcusDenker.271';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.119';
			package: 'Camel-Core' with: 'Camel-Core-HolgerHansPeterFreyther.11';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8'. ].
]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> version77: spec [
	<version: '7.7' imports: #('0.7-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 7.6'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '10/30/2016 17:40'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'ASN1' with: '1.1';
			project: 'ASN1-Tool' with: '1.1';
			project: 'ASN1-Builder' with: '1.1';
			project: 'ASN1-Tests-Builder' with: '1.1';
			project: 'ASN1 full' with: '1.1';
			project: 'ASN1-Tests-Tool' with: '1.1';
			project: 'OsmoCore' with: '2';
			project: 'OsmoNetwork' with: '4';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.64';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'STON-Core' with: 'STON-Core-NorbertHartl.64';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.76';
			package: 'TCAP-Core' with: 'TCAP-Core-MarcusDenker.271';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.119';
			package: 'Camel-Core' with: 'Camel-Core-HolgerHansPeterFreyther.11';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8'. ].
]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> version78: spec [
	<version: '7.8' imports: #('0.7-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 7.8'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '02/04/2017 20:03'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'ASN1' with: '1.1';
			project: 'ASN1-Tool' with: '1.1';
			project: 'ASN1-Builder' with: '1.1';
			project: 'ASN1-Tests-Builder' with: '1.1';
			project: 'ASN1 full' with: '1.1';
			project: 'ASN1-Tests-Tool' with: '1.1';
			project: 'OsmoCore' with: '2';
			project: 'OsmoNetwork' with: '4';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.64';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'STON-Core' with: 'STON-Core-NorbertHartl.64';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.78';
			package: 'TCAP-Core' with: 'TCAP-Core-MarcusDenker.271';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.119';
			package: 'Camel-Core' with: 'Camel-Core-HolgerHansPeterFreyther.12';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8'. ].
]

{ #category : #'as yet unclassified' }
ConfigurationOfTCAP >> version79: spec [
	<version: '7.9' imports: #('0.7-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 7.9'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '03/09/2017 10:02'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'ASN1' with: '1.1';
			project: 'ASN1-Tool' with: '1.1';
			project: 'ASN1-Builder' with: '1.1';
			project: 'ASN1-Tests-Builder' with: '1.1';
			project: 'ASN1 full' with: '1.1';
			project: 'ASN1-Tests-Tool' with: '1.1';
			project: 'OsmoCore' with: '2';
			project: 'OsmoNetwork' with: '4';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.64';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'STON-Core' with: 'STON-Core-NorbertHartl.64';
			package: 'MAP-Core' with: 'MAP-Core-HolgerHansPeterFreyther.80';
			package: 'TCAP-Core' with: 'TCAP-Core-MarcusDenker.271';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.119';
			package: 'Camel-Core' with: 'Camel-Core-HolgerHansPeterFreyther.12';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8'. ].
]

{ #category : #versions }
ConfigurationOfTCAP >> version7: spec [
	<version: '7' imports: #('0.7-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 7'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '2/14/2016 19:39'.
		spec 
			project: 'Phexample' with: '1.2';
			project: 'ASN1' with: '1';
			project: 'ASN1-Tool' with: '1';
			project: 'ASN1-Builder' with: '1';
			project: 'ASN1-Tests-Builder' with: '1';
			project: 'ASN1 full' with: '1';
			project: 'ASN1-Tests-Tool' with: '1';
			project: 'OsmoCore' with: '1';
			project: 'OsmoNetwork' with: '3';
			project: 'Fuel' with: '1.9.4'.
		spec 
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.64';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'STON-Core' with: 'STON-Core-NorbertHartl.64';
			package: 'MAP-Core' with: 'MAP-Core-NorbertHartl.71';
			package: 'TCAP-Core' with: 'TCAP-Core-MarcusDenker.271';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.119';
			package: 'Camel-Core' with: 'Camel-Core-NorbertHartl.10';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8'. ].
]

{ #category : #versions }
ConfigurationOfTCAP >> version8: spec [
	<version: '8' imports: #('0.8-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 8'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '5/29/2016 12:12'.
		spec 
			project: 'ASN1' with: '1';
			project: 'ASN1-Tool' with: '1';
			project: 'ASN1-Builder' with: '1';
			project: 'ASN1-Tests-Builder' with: '1';
			project: 'ASN1 full' with: '1';
			project: 'ASN1-Tests-Tool' with: '1';
			project: 'Fuel' with: '1.9.4';
			project: 'OsmoCore' with: '1';
			project: 'OsmoNetwork' with: '3';
			project: 'Phexample' with: '1.2'.
		spec 
			package: 'Camel-Core' with: 'Camel-Core-HolgerHansPeterFreyther.11';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8';
			package: 'MAP-Core' with: 'MAP-Core-NorbertHartl.71';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.141';
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.74';
			package: 'STON-Core' with: 'STON-Core-NorbertHartl.64';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'TCAP-Core' with: 'TCAP-Core-HolgerHansPeterFreyther.286'. ].

]

{ #category : #versions }
ConfigurationOfTCAP >> version9: spec [
	<version: '9' imports: #('0.9-baseline' )>

	spec for: #'common' do: [
		spec blessing: #'stable'.
		spec description: 'version 9'.
		spec author: 'HolgerHansPeterFreyther'.
		spec timestamp: '5/30/2016 22:17'.
		spec 
			project: 'ASN1' with: '1';
			project: 'ASN1-Tool' with: '1';
			project: 'ASN1-Builder' with: '1';
			project: 'ASN1-Tests-Builder' with: '1';
			project: 'ASN1 full' with: '1';
			project: 'ASN1-Tests-Tool' with: '1';
			project: 'Fuel' with: '1.9.4';
			project: 'OsmoCore' with: '1';
			project: 'OsmoNetwork' with: '3';
			project: 'Phexample' with: '1.2'.
		spec 
			package: 'Camel-Core' with: 'Camel-Core-HolgerHansPeterFreyther.11';
			package: 'Camel-SCF' with: 'Camel-SCF-NorbertHartl.8';
			package: 'MAP-Core' with: 'MAP-Core-NorbertHartl.71';
			package: 'Q787-TestSpec' with: 'Q787-TestSpec-MarcusDenker.141';
			package: 'ROS-Core' with: 'ROS-Core-MarcusDenker.74';
			package: 'STON-Core' with: 'STON-Core-NorbertHartl.64';
			package: 'TCAP-Benchmark' with: 'TCAP-Benchmark-NorbertHartl.3';
			package: 'TCAP-Core' with: 'TCAP-Core-HolgerHansPeterFreyther.287'. ].

]
