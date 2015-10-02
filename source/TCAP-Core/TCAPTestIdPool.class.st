Class {
	#name : #TCAPTestIdPool,
	#superclass : #TCAPIdPool,
	#instVars : [
		'isExausted'
	],
	#category : #'TCAP-Core-Tests-Model'
}

{ #category : #accessing }
TCAPTestIdPool >> basicNextId [
	^ mutex critical: [
			pool max + 100000 atRandom ]
]

{ #category : #accessing }
TCAPTestIdPool >> beExhausted [
	isExausted := true
]

{ #category : #'initialize-release' }
TCAPTestIdPool >> initialize [ 
	super initialize.
	isExausted := false
]

{ #category : #accessing }
TCAPTestIdPool >> nextId [ 
	^ isExausted 
		ifTrue: [ TCAPNoFreeId signal ]
		ifFalse: [  super nextId ]
]
