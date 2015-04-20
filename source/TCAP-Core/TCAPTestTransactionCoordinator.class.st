Class {
	#name : #TCAPTestTransactionCoordinator,
	#superclass : #TCAPTransactionCoordinator,
	#instVars : [
		'postProcessPayLoadBlock',
		'postProcessDictionaryBlock'
	],
	#category : #'TCAP-Core-Tests-Model'
}

{ #category : #accessing }
TCAPTestTransactionCoordinator >> asn1 [
	^ TestASN1 
]

{ #category : #accessing }
TCAPTestTransactionCoordinator >> dialogueHandler [
	^ container dialogueHandler 
]

{ #category : #'as yet unclassified' }
TCAPTestTransactionCoordinator >> encodePayload: aPayload [
	| payload |
	payload := super encodePayload: aPayload.
	postProcessPayLoadBlock ifNotNil: [ 
		payload := postProcessPayLoadBlock value: payload ].
	^ payload
]

{ #category : #accessing }
TCAPTestTransactionCoordinator >> postProcessDictionary: aBlock [
	postProcessDictionaryBlock  := aBlock
]

{ #category : #accessing }
TCAPTestTransactionCoordinator >> postProcessPayload: aBlock [
	postProcessPayLoadBlock := aBlock
]

{ #category : #'as yet unclassified' }
TCAPTestTransactionCoordinator >> sendPayload: aDictionary to: aDestinationAddress from: anOriginatingAddress [
	postProcessDictionaryBlock ifNotNil: [ 
		postProcessDictionaryBlock value: aDictionary ].
	super sendPayload: aDictionary to: aDestinationAddress from: anOriginatingAddress
]
