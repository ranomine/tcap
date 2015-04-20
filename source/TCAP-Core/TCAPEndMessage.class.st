Class {
	#name : #TCAPEndMessage,
	#superclass : #TCAPEntityMessage,
	#category : #'TCAP-Core-Model'
}

{ #category : #'initailize-release' }
TCAPEndMessage class >> asn1TypeName [
	^ 'End'
]

{ #category : #'instance creation' }
TCAPEndMessage class >> dispatchInstanceCreationOn: aFactory [ 
	^ aFactory newEndMessage
]

{ #category : #'as yet unclassified' }
TCAPEndMessage class >> isAsn1ModelClass [
	^ true
]

{ #category : #'as yet unclassified' }
TCAPEndMessage class >> type [
	^ 'end'
]

{ #category : #'as yet unclassified' }
TCAPEndMessage >> dispatchTo: aTransaction [
	aTransaction receivedEnd: self
]

{ #category : #'as yet unclassified' }
TCAPEndMessage >> handleSyntaxError [
	self abortLocalTransaction
]

{ #category : #'as yet unclassified' }
TCAPEndMessage >> handleUnassignedTransaction [
	self discard
]

{ #category : #validating }
TCAPEndMessage >> validateSyntax [ 
	super validateSyntax.
	self validateDtidSyntax
]
