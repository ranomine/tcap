Class {
	#name : #TCAPBinaryMessage,
	#superclass : #Object,
	#instVars : [
		'bytes',
		'taggedValue'
	],
	#category : #'TCAP-Core-Model'
}

{ #category : #'instance creation' }
TCAPBinaryMessage class >> on: aByteArray [ 
	^ self new 
		bytes: aByteArray
]

{ #category : #accessing }
TCAPBinaryMessage >> bytes: aByteArray [ 
	bytes := aByteArray
]

{ #category : #'as yet unclassified' }
TCAPBinaryMessage >> entityMessageFor: aTaggedValue [
	^ [ (TCAPEntityMessage forTaggedValue: aTaggedValue) ]
			on: TCAPMessageTypeUnknown 
			do: [:err | |  otid dtid |
				"the type of message is unknown. Send back an abort with the
				information in the structure"
				"dict := self recoveryRead: aTaggedValue."
				otid := ASN1 octetStringFrom: aTaggedValue withTagNumber: 8. 
				dtid := ASN1 octetStringFrom: aTaggedValue withTagNumber: 9. 
				(TCAPFullAbort otid: otid dtid: dtid cause: TCAPDialoguePAbort unrecognizedMessageType) signal.
				TCAPProcessingAborted signal ]
]

{ #category : #'as yet unclassified' }
TCAPBinaryMessage >> readTaggedValue [
	"read the tagged value structure into tagged values. If this fails we consider the
	message only useful for recovery read for an abort"
	^ ASN1 readTaggedValuesFrom: bytes readStream 
]

{ #category : #accessing }
TCAPBinaryMessage >> taggedValue [
	^ taggedValue ifNil: [ 
		taggedValue := self readTaggedValue  ]
]
