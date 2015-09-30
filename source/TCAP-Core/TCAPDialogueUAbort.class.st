Class {
	#name : #TCAPDialogueUAbort,
	#superclass : #TCAPDialogueAPDU,
	#instVars : [
		'source'
	],
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

{ #category : #'instance creation' }
TCAPDialogueUAbort class >> serviceProvider [
self halt.
	^ 1 
]

{ #category : #converting }
TCAPDialogueUAbort >> asAbort [
	| abort |
	self halt.
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
