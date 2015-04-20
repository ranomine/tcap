"
A TCAPEntityMessageTest is a test class for testing the behavior of TCAPEntityMessage
"
Class {
	#name : #TCAPEntityMessageTest,
	#superclass : #TestCase,
	#category : #'TCAP-Core-Tests'
}

{ #category : #accessing }
TCAPEntityMessageTest >> asn1Context [
	^ ASN1Context new
		model: TCAPTestModel instance asTcapModelRoot;
		factory: TCAPTestObjectFactory new
]

{ #category : #accessing }
TCAPEntityMessageTest >> asn1Model [
	^ self asn1Context model
]

{ #category : #'as yet unclassified' }
TCAPEntityMessageTest >> runCase [
	ASN1CurrentContext
		value: self asn1Context
		during: [ super runCase ]
]

{ #category : #'as yet unclassified' }
TCAPEntityMessageTest >> testEncodingTaggedType [
	| val data |
	val := ('PurgeMS-ArgV3' asAsn1ValueTypedIn: self asn1Model)
            imsi: '1234' toTBCD;
            vlr_Number: '1234' toE164;
            yourself.

	data := val encodeToByteArray.
	
	self assert: data first = 16rA3
]

{ #category : #'as yet unclassified' }
TCAPEntityMessageTest >> testFromByteArray [
	| msg |
	"We are mostly interested in not raising an exception here."
	ASN1CurrentContext
		value: self asn1Context
		during: [  
			msg := TCAPEntityMessage fromByteArray: (TCAPExamplePackets exampleTcapBeginPacket) ].

	"Some dummy checks"
	self deny: msg isNil.
	self assert: msg entityMessage class equals: TCAPBeginMessage.
]
