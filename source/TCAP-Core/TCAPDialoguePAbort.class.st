Class {
	#name : #TCAPDialoguePAbort,
	#superclass : #ASN1PrimitiveValue,
	#category : #'TCAP-Core-Model'
}

{ #category : #'initailize-release' }
TCAPDialoguePAbort class >> asn1TypeName [
	^ 'P-AbortCause'
]

{ #category : #'instance creation' }
TCAPDialoguePAbort class >> badlyFormattedTransactionPortion [
	^ self new
		value: 2
]

{ #category : #'instance creation' }
TCAPDialoguePAbort class >> incorrectCauseValue [
	^ self new
		value: 5
]

{ #category : #'instance creation' }
TCAPDialoguePAbort class >> incorrectTransactionPortion [
	^ self new
		value: 3
]

{ #category : #'as yet unclassified' }
TCAPDialoguePAbort class >> isAsn1ModelClass [
	^ true
]

{ #category : #'instance creation' }
TCAPDialoguePAbort class >> resourceLimitation [
	^ self new
		value: 4
]

{ #category : #'instance creation' }
TCAPDialoguePAbort class >> unrecognizedMessageType [
	^ self new
		value: 0
]

{ #category : #'instance creation' }
TCAPDialoguePAbort class >> unrecognizedTransactionID [
	^ self new
		value: 1
]

{ #category : #converting }
TCAPDialoguePAbort >> asAbort [
	| abort |
	self halt.
	abort := (self asn1TypeNamed: 'Abort') asAsn1Value.
	(abort expandFieldNamed: 'reason') 
		at: 'p-abortCause' put: self.
	^ abort
		
]

{ #category : #converting }
TCAPDialoguePAbort >> asAbortIn: aFactory [
	| abort |
	abort := aFactory newAbortMessage.
	(abort expandFieldNamed: 'reason') 
		at: 'p-abortCause' put: self.
	^ abort
		
]

{ #category : #accessing }
TCAPDialoguePAbort >> unrecognizedMessageType [
	self value: 0
]
