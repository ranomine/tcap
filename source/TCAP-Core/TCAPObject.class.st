Class {
	#name : #TCAPObject,
	#superclass : #Object,
	#instVars : [
		'asn1Context'
	],
	#category : #'TCAP-Core-Model'
}

{ #category : #accessing }
TCAPObject >> asn1Context [
	^ asn1Context ifNil: [ 
		asn1Context := ASN1Context new ] 
]

{ #category : #accessing }
TCAPObject >> asn1Model [
	^ self asn1Context model
]

{ #category : #accessing }
TCAPObject >> asn1Model: anObject [
	self asn1Context model: anObject
]

{ #category : #accessing }
TCAPObject >> defaultFactoryClass [
	^ TCAPObjectFactory 
]

{ #category : #accessing }
TCAPObject >> factory [
	^ self asn1Context factory ifNil: [  | factory |
		factory := self defaultFactoryClass new.
		self asn1Context factory: factory.
		factory ]
]

{ #category : #accessing }
TCAPObject >> factory: aFactory [
	self asn1Context factory: aFactory
]

{ #category : #'as yet unclassified' }
TCAPObject >> tcapModule [
	^ self asn1Model moduleNamed: 'TCAPMessages'
]

{ #category : #model }
TCAPObject >> withCurrentContextDo: aBlock [
	^ ASN1CurrentContext
		value: self asn1Context
		during: aBlock
]
