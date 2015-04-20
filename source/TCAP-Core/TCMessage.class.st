Class {
	#name : #TCMessage,
	#superclass : #ASN1AdaptiveTypeObject,
	#category : #'TCAP-Core-Model'
}

{ #category : #'as yet unclassified' }
TCMessage class >> asn1TypeName [
	^ 'TCMessage'
]

{ #category : #'instance creation' }
TCMessage class >> dispatchInstanceCreationOn: anObjectFactory [ 
	^ anObjectFactory newTCMessage
]

{ #category : #'as yet unclassified' }
TCMessage class >> isAsn1ModelClass [
	^ true
]

{ #category : #accessing }
TCMessage >> abort [
	^ self at: 'abort'
]

{ #category : #accessing }
TCMessage >> begin [
	^ self at: 'begin'
]

{ #category : #accessing }
TCMessage >> continue [
	^ self at: 'continue'
]

{ #category : #accessing }
TCMessage >> end [
	^ self at: 'end'
]

{ #category : #accessing }
TCMessage >> entityMessage [
	^ map values 
		ifNotEmpty: [ :m | m first ]
		ifEmpty: [ TCAPInvalidEntityMessage new ]
]

{ #category : #accessing }
TCMessage >> realEntityMessage [
	^ self entityMessage realMessage 
]

{ #category : #validating }
TCMessage >> validateSyntax [
	self entityMessage validateSyntax
]
