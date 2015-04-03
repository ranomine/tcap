Class {
	#name : #MAPApplicationContext,
	#superclass : #Object,
	#instVars : [
		'oid',
		'initiatorConsumerOf',
		'responderConsumerOf'
	],
	#category : #'MAP-Core'
}

{ #category : #'as yet unclassified' }
MAPApplicationContext class >> newFrom: anAsn1Object [ 
	^ self new
		initializeFrom: anAsn1Object
]

{ #category : #initialize }
MAPApplicationContext >> initializeFrom: anAsn1Object [ 
	oid := anAsn1Object attributeAt: 'applicationContextName'.
	self halt.
	self flag: #todo. "This now has a contract which answers to InitiatorConsumerOf/ResponderC..."
	initiatorConsumerOf := (anAsn1Object attributeAt: 'InitiatorConsumerOf').
	responderConsumerOf := (anAsn1Object attributeAt: 'ResponderConsumerOf').
	
]
