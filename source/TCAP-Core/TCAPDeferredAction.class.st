Class {
	#name : #TCAPDeferredAction,
	#superclass : #Object,
	#instVars : [
		'block'
	],
	#category : #'TCAP-Core-Tests-Model'
}

{ #category : #'as yet unclassified' }
TCAPDeferredAction class >> for: aBlock [ 
	^ self new 
		initializeOn: aBlock;
		prepare
]

{ #category : #'as yet unclassified' }
TCAPDeferredAction >> initializeOn: aBlock [ 
	block := aBlock
]

{ #category : #'as yet unclassified' }
TCAPDeferredAction >> prepare [
	| ret  interCtx |
	interCtx := [  
		ret := self dummy.
		block value.
		ret] asContext.
	interCtx pc: interCtx startpc + 2.
	interCtx swapSender: (self targetContext swapSender: interCtx) 

]

{ #category : #'as yet unclassified' }
TCAPDeferredAction >> targetContext [
	| targetCtx |
	targetCtx := thisContext.
	[targetCtx sender method methodClass includesBehavior: TestCase] whileFalse: [ 
		targetCtx  := targetCtx sender ].
	^ targetCtx 
]
