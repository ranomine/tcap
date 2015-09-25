Class {
	#name : #TCAPDialogueRequest,
	#superclass : #TCAPDialogueAPDU,
	#category : #'TCAP-Core-Model'
}

{ #category : #'initailize-release' }
TCAPDialogueRequest class >> asn1TypeName [
	^ 'AARQ-apdu'
]

{ #category : #'instance creation' }
TCAPDialogueRequest class >> dispatchInstanceCreationOn: anObjectFactory [ 
	^ anObjectFactory newDialogueRequest
]

{ #category : #'as yet unclassified' }
TCAPDialogueRequest class >> isAsn1ModelClass [
	^ true
]

{ #category : #accessing }
TCAPDialogueRequest >> applicationContextName: anOid [
	(self value expandFieldNamed: 'application-context-name') value: anOid
]

{ #category : #accessing }
TCAPDialogueRequest >> pduType [
	^ 'dialogueRequest'
]
