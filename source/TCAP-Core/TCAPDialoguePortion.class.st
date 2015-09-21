Class {
	#name : #TCAPDialoguePortion,
	#superclass : #ASN1TaggedValue,
	#category : #'TCAP-Core-Model'
}

{ #category : #accessing }
TCAPDialoguePortion class >> asn1TypeName [
	^ 'DialoguePortion'
]

{ #category : #'as yet unclassified' }
TCAPDialoguePortion class >> isAsn1ModelClass [
	^ true
]

{ #category : #'as yet unclassified' }
TCAPDialoguePortion >> valueClass [
	^ TCAPDialoguePDU 
]
