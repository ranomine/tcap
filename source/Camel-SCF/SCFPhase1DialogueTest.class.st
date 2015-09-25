Class {
	#name : #SCFPhase1DialogueTest,
	#superclass : #TestCase,
	#instVars : [
		'scfEndPoint',
		'testEndPoint',
		'subscriber',
		'testSCF'
	],
	#category : #'Camel-SCF-Tests'
}

{ #category : #'as yet unclassified' }
SCFPhase1DialogueTest >> applicationContextFor: aString [
	^ self asn1Model applicationContextOidForOperationNamed: aString
]

{ #category : #'as yet unclassified' }
SCFPhase1DialogueTest >> asn1Model [
	^ CamelTestModel instance
]

{ #category : #'as yet unclassified' }
SCFPhase1DialogueTest >> imsiAddr [
	"Use the IMSI to the Address the HLR.."
	| gt |
	gt := SCCPGlobalTitleTranslation new
			translation: 0;
			plan: 6;
			nature: 4;
			addr: '1234567';
			asByteArray.
	^self scfAddr
		globalTitle: gt indicator: 4.
]

{ #category : #'as yet unclassified' }
SCFPhase1DialogueTest >> localAddr [
	^ (SCCPAddress createWith: 7) 
		pointCode: 11;
		routedOnSSN: true;
		yourself
]

{ #category : #'as yet unclassified' }
SCFPhase1DialogueTest >> scfAddr [
	^ (SCCPAddress createWith: 6) 
		pointCode: 2000;
		routedOnSSN: true; 
		yourself
]

{ #category : #'as yet unclassified' }
SCFPhase1DialogueTest >> setUp [
	testEndPoint := TCAPTestServiceEndPoint newCamel
		asn1Model: self asn1Model.
	scfEndPoint := TCAPTestServiceEndPoint newSCF
		asn1Model: self asn1Model.
	scfEndPoint transactionCoordinator: TCAPTestTransactionCoordinator new.
	scfEndPoint factory scf: testSCF.

	testEndPoint connectTo: scfEndPoint.
	scfEndPoint connectTo: testEndPoint.
]

{ #category : #'as yet unclassified' }
SCFPhase1DialogueTest >> testInitialDPV1 [
	| dialogue invoke params invokeResult operation |

	dialogue := testEndPoint newDialogue.
	dialogue
		onInvoke: [:in | invokeResult := in].
	operation := dialogue rosOperationNamed: 'initialDPV1'.
	params := operation argumentValue
		at: 'serviceKey' put: 23;
		yourself.

	invoke := dialogue requestTcInvoke: operation parameters: params class: 1 timeout: 500.
	invoke
		onReturn: [self assert: false];
		onError: [self assert: false];
		onReject: [self assert: false];
		onReturnLast: [self assert: false].

	dialogue
		requestTcBeginDestinationAddress: self imsiAddr
		originatingAddress: self localAddr
		applicationContextName: (self applicationContextFor: 'initialDPV1').

	self deny: invokeResult isNil.
	self assert: invokeResult invocation operationName = 'releaseCallV1'
]
