Class {
	#name : #TCAPTestCase,
	#superclass : #TCAPExecutorTest,
	#category : #'TCAP-Core-Tests'
}

{ #category : #'as yet unclassified' }
TCAPTestCase >> anyApplicationContextId [
	^ (self asn1Model applicationContexts anyOne attributeAt: 'applicationContextName') contents
]

{ #category : #'as yet unclassified' }
TCAPTestCase >> asn1Context [
	^ ASN1Context new
		model: TCAPTestModel instance asTcapModelRoot;
		factory: TCAPTestObjectFactory new
]

{ #category : #'as yet unclassified' }
TCAPTestCase >> asn1Model [
	^ self asn1Context model
]

{ #category : #'as yet unclassified' }
TCAPTestCase >> destinationAddress [
	^ SCCPAddress createForSSN: #AUC
]

{ #category : #'as yet unclassified' }
TCAPTestCase >> messageInspectorOn: aByteArray [
	^ (TCAPMessageInspector packet: aByteArray) 
		asn1Model: self asn1Model
]

{ #category : #'as yet unclassified' }
TCAPTestCase >> newTestEnvironment [
	^ TCAPTestEnvironment new
		asn1Context: self asn1Context
]

{ #category : #creating }
TCAPTestCase >> newValueOfTypeNamed: aString [ 
	^ (self asn1Model typeNamed: aString) newValue
]

{ #category : #'as yet unclassified' }
TCAPTestCase >> originatingAddress [
	^ SCCPAddress createForSSN: #HLR
]

{ #category : #tests }
TCAPTestCase >> shouldCreateTestEnvironment [
	| env |
	env := self newTestEnvironment.
	env localAddressIs: #HLR.
	env remoteAddressIs: #AUC.
	env connect.
	self assert: env servicePointA isIdle.
	self assert: env servicePointB isIdle.
	^ env
	
]

{ #category : #'as yet unclassified' }
TCAPTestCase >> tcapModule [
	^ self asn1Model moduleNamed: 'TCAPMessages'
]
