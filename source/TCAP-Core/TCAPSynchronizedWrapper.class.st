Class {
	#name : #TCAPSynchronizedWrapper,
	#superclass : #ProtoObject,
	#instVars : [
		'object'
	],
	#category : #'TCAP-Core-Model'
}

{ #category : #'instance-creation' }
TCAPSynchronizedWrapper class >> on: aTCAPEnvironment [
	^ self new 
		object: aTCAPEnvironment
]

{ #category : #converting }
TCAPSynchronizedWrapper >> asSynchronizedWrapper [
	^ self
]

{ #category : #dispatching }
TCAPSynchronizedWrapper >> doesNotUnderstand: aMessage [
	| returnValue |
	returnValue := object critical: [ 
		aMessage sendTo: object  ].
	^ (returnValue = object)
		ifTrue: [ self ]
		ifFalse: [ returnValue ] 
]

{ #category : #accessing }
TCAPSynchronizedWrapper >> object: anObject [
	object := anObject
]

{ #category : #printing }
TCAPSynchronizedWrapper >> printOn: aStream [
	aStream
		nextPutAll: 'synchronized -> '.
	object printOn: aStream
]

{ #category : #printing }
TCAPSynchronizedWrapper >> printString [
	^ String streamContents: [ :stream |
		self printOn: stream ]
]
