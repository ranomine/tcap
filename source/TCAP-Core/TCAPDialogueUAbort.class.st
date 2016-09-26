Class {
	#name : #TCAPDialogueUAbort,
	#superclass : #TCAPDialogueAPDU,
	#category : #'TCAP-Core-Message'
}

{ #category : #'initailize-release' }
TCAPDialogueUAbort class >> asn1TypeName [
	^ 'ABRT-apdu'
]

{ #category : #'as yet unclassified' }
TCAPDialogueUAbort class >> isAsn1ModelClass [
	^ true
]

{ #category : #converting }
TCAPDialogueUAbort >> asAbort [
	| abort |
	abort := (self asn1TypeNamed: 'Abort') newValue.
	(abort expandFieldNamed: 'reason')
		at: 'u-abortCause' put: self asExternalValue.
	^ abort
]

{ #category : #converting }
TCAPDialogueUAbort >> asAbortIn: aFactory [
	| abort |
	abort := aFactory newAbortMessage.
	(abort expandFieldNamed: 'reason')
		privAt: 'u-abortCause' put: (aFactory dialoguePortionFromApdu: self).
	^ abort
]

{ #category : #testing }
TCAPDialogueUAbort >> isRefused [
	^ false
]

{ #category : #accessing }
TCAPDialogueUAbort >> pduType [
	^ 'dialogueAbort'
]

{ #category : #accessing }
TCAPDialogueUAbort >> serviceProvider [
	(self expandFieldNamed: 'abort-source') value: 1
]

{ #category : #accessing }
TCAPDialogueUAbort >> serviceUser [
	self value at: 'abort-source' put: 0
]
