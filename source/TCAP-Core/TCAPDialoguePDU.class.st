Class {
	#name : #TCAPDialoguePDU,
	#superclass : #ASN1AdaptiveTypeObject,
	#category : #'TCAP-Core-Model'
}

{ #category : #'initailize-release' }
TCAPDialoguePDU class >> asn1TypeName [
	^ 'DialoguePDU'
]

{ #category : #'instance creation' }
TCAPDialoguePDU class >> dispatchInstanceCreationOn: anObjectFactory [ 
	^ anObjectFactory newDialoguePDU
]

{ #category : #'as yet unclassified' }
TCAPDialoguePDU class >> isAsn1ModelClass [
	^ true
]

{ #category : #accessing }
TCAPDialoguePDU >> oidName [
	^ 'dialogue-as-id'
]

{ #category : #accessing }
TCAPDialoguePDU >> pduType [
	^ map keys anyOne
]
