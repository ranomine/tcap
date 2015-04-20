Class {
	#name : #TCAPDialoguePortion,
	#superclass : #ASN1AdaptiveTypeExternal,
	#category : #'TCAP-Core-Model'
}

{ #category : #accessing }
TCAPDialoguePortion class >> asn1InstanceFactory [
	^ [ :type | TCAPDialoguePortion new type:type;  oid: (type asn1TypeNamed: 'dialogue-as-id')]
]

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
