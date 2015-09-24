Class {
	#name : #TCAPDialoguePAbort,
	#superclass : #ASN1TaggedValue,
	#category : #'TCAP-Core-Model'
}

{ #category : #'initailize-release' }
TCAPDialoguePAbort class >> asn1TypeName [
	^ 'P-AbortCause'
]

{ #category : #'instance creation' }
TCAPDialoguePAbort class >> badlyFormattedTransactionPortion [
	^  2
]

{ #category : #'instance creation' }
TCAPDialoguePAbort class >> incorrectCauseValue [
	^ 5
]

{ #category : #'instance creation' }
TCAPDialoguePAbort class >> incorrectTransactionPortion [
	^ 3 
]

{ #category : #'as yet unclassified' }
TCAPDialoguePAbort class >> isAsn1ModelClass [
	^ true
]

{ #category : #'instance creation' }
TCAPDialoguePAbort class >> resourceLimitation [
	^ 4
]

{ #category : #'instance creation' }
TCAPDialoguePAbort class >> unrecognizedMessageType [
	^ 0
]

{ #category : #'instance creation' }
TCAPDialoguePAbort class >> unrecognizedTransactionID [
	^ 1
]

{ #category : #converting }
TCAPDialoguePAbort >> asAbort [
	| abort |
	self halt.
	abort := (self asn1TypeNamed: 'Abort') newValue.
	(abort expandFieldNamed: 'reason') 
		at: 'p-abortCause' put: self.
	^ abort
		
]

{ #category : #converting }
TCAPDialoguePAbort >> asAbortIn: aFactory [
	| abort |
	abort := aFactory newAbortMessage.
	(abort expandFieldNamed: 'reason') 
		privAt: 'p-abortCause' put: self.
	^ abort
		
]

{ #category : #accessing }
TCAPDialoguePAbort >> incorrectTransactionPortion [
	self basicValue: 3
]

{ #category : #accessing }
TCAPDialoguePAbort >> unrecognizedMessageType [
	self basicValue: 0
]
