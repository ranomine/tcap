Class {
	#name : #TCAPAbortMessage,
	#superclass : #TCAPEntityMessage,
	#category : #'TCAP-Core-Model'
}

{ #category : #accessing }
TCAPAbortMessage class >> asn1TypeName [
	^ 'Abort'
]

{ #category : #'instance creation' }
TCAPAbortMessage class >> dispatchInstanceCreationOn: aFactory [ 
	^ aFactory newAbortMessage
]

{ #category : #'as yet unclassified' }
TCAPAbortMessage class >> isAsn1ModelClass [
	^ true
]

{ #category : #'as yet unclassified' }
TCAPAbortMessage class >> type [
	^ 'abort'
]

{ #category : #'as yet unclassified' }
TCAPAbortMessage >> dispatchTo: aTransaction [
	aTransaction receivedAbort: self
]

{ #category : #'as yet unclassified' }
TCAPAbortMessage >> handleSyntaxError [
	self abortLocalTransaction
]

{ #category : #'as yet unclassified' }
TCAPAbortMessage >> handleUnassignedTransaction [
	self discard
]

{ #category : #'as yet unclassified' }
TCAPAbortMessage >> hasReason [
	^ self includesKey: 'reason'
]

{ #category : #testing }
TCAPAbortMessage >> isUAbort [
	^ self hasReason and: [ self uAbortCause notNil ]
]

{ #category : #accessing }
TCAPAbortMessage >> pAbortCause [
	^ self reason ifNotNil: [:r|
		r at: 'p-abortCause' ]
]

{ #category : #converting }
TCAPAbortMessage >> realMessage [
	^ self isUAbort 
		ifTrue: [ 
			TCAPUserAbortMessage new 
				type: type;
				setMap: map ]
		ifFalse: [ 
			TCAPProtocolAbortMessage new 
				type: type;
				setMap: map ]
]

{ #category : #accessing }
TCAPAbortMessage >> reason [
	^ self at: 'reason'
]

{ #category : #accessing }
TCAPAbortMessage >> uAbortCause [
	^ self reason at: 'u-abortCause' ifAbsent: [ nil ]
]

{ #category : #validating }
TCAPAbortMessage >> validateProtocolVersion [
]

{ #category : #validating }
TCAPAbortMessage >> validateSyntax [ 
	super validateSyntax.
	self validateDtidSyntax
]
