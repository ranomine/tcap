Class {
	#name : #BaselineOfTCAP,
	#superclass : #BaselineOf,
	#category : #BaselineOfTCAP
}

{ #category : #baselines }
BaselineOfTCAP >> baseline: spec [
	<baseline>

	spec baseline: 'OsmoLogging' with: [
		spec
			repository: 'github://moiji-mobile/osmocom-logging:v8/source'].
	spec baseline: 'OsmoCore' with: [
		spec
			repository: 'github://moiji-mobile/osmocom-core:v8/source'].
	spec baseline: 'OsmoNetwork' with: [
		spec
			repository: 'github://moiji-mobile/osmocom-network:v10/source'].
	spec baseline: 'PetitParser' with: [
		spec
			repository: 'github://moosetechnology/PetitParser:v2.2.0/src';
			loads: #( 'Core' ) ].
	spec baseline: 'ASN1' with: [
		spec
			repository: 'github://noha/ASN.1:master';
			loads: #( 'default' ) ].
	spec project: 'ASN1 Full' copyFrom: 'ASN1' with: [
		spec loads: #( 'tests' )].
	spec baseline: 'Phexample' with: [
		spec
			repository: 'github://jecisc/Phexample:v1.0.1/src' ].
	spec baseline: 'Ston' with: [
		spec
			repository: 'github://svenvc/ston:v8.0/repository' ].

	spec
		package: 'Camel-Core' with: [ 
			spec requires: #('TCAP-Core') ];
		package: 'Camel-SCF' with: [
			spec requires: #('Camel-Core') ];
		package: 'MAP-Core' with: [
			spec requires: #('ROS-Core' 'Ston') ];
		package: 'Q787-TestSpec' with: [
			spec requires: #('TCAP-Core' 'OsmoNetwork') ];
		package: 'ROS-Core' with: [
			spec requires: #('ASN1') ];
		package: 'TCAP-Benchmark';
		package: 'TCAP-Core' with: [
			spec requires: #('ASN1' 'ASN1 Full' 'MAP-Core' 'Phexample' 'OsmoCore' 'OsmoNetwork' ).
		].

	spec
			group: 'all' with: #('default' 'ASN1 Full' 'tests' 'camel' );
			group: 'bench' with: #('default' 'TCAP-Benchmark' );
			group: 'camel' with: #('default' 'Camel-Core' 'Camel-SCF' );
			group: 'default' with: #('ASN1' 'ROS-Core' 'MAP-Core' 'TCAP-Core' );
			group: 'q787' with: #('Q787-TestSpec' );
			group: 'tests' with: #('Q787-TestSpec' ).
]
