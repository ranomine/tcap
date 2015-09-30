Class {
	#name : #TCAPContinueMessage,
	#superclass : #TCAPEntityMessage,
	#category : #'TCAP-Core-Message'
}

{ #category : #'initailize-release' }
TCAPContinueMessage class >> asn1TypeName [
	^ 'Continue'
]

{ #category : #'instance creation' }
TCAPContinueMessage class >> dispatchInstanceCreationOn: aFactory [ 
	^ aFactory newContinueMessage
]

{ #category : #'as yet unclassified' }
TCAPContinueMessage class >> isAsn1ModelClass [
	^ true
]

{ #category : #'as yet unclassified' }
TCAPContinueMessage class >> type [
	^ 'continue'
]

{ #category : #'as yet unclassified' }
TCAPContinueMessage >> dispatchTo: aTransaction [
	aTransaction receivedContinue: self
]

{ #category : #'as yet unclassified' }
TCAPContinueMessage >> handleSyntaxError [
	(TCAPFullAbort
		otid: self otid 
		dtid: self dtid 
		cause: TCAPDialoguePAbort incorrectTransactionPortion) signal 
]

{ #category : #'as yet unclassified' }
TCAPContinueMessage >> handleUnassignedTransaction [
	self abortRemoteTransactionCause: TCAPDialoguePAbort unrecognizedTransactionID
]

{ #category : #validating }
TCAPContinueMessage >> validateSyntax [ 
	super validateSyntax.
	self validateOtidSyntax.
	self validateDtidSyntax 
]
