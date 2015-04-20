Class {
	#name : #TCAPExecutorTest,
	#superclass : #Phexample,
	#instVars : [
		'executor'
	],
	#category : #'TCAP-Core-Tests'
}

{ #category : #'as yet unclassified' }
TCAPExecutorTest >> execute: aBlock [
	executor notNil 
		ifTrue: [ executor execute: aBlock ]
		ifFalse: [ aBlock value ]
]
