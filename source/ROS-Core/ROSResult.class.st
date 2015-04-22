Class {
	#name : #ROSResult,
	#superclass : #ROSMessage,
	#instVars : [
		'encodedResult'
	],
	#category : #'ROS-Core'
}

{ #category : #'as yet unclassified' }
ROSResult class >> asn1TypeName [
	^ 'ReturnResultNotLast'
]

{ #category : #'as yet unclassified' }
ROSResult class >> isAsn1ModelClass [
	^ false
]

{ #category : #accessing }
ROSResult class >> rosMessageType [
	^ 'returnResultNotLast'
]

{ #category : #decoding }
ROSResult >> decodeResult [

	self result result isAsn1TaggedValue ifTrue: [  
		self result result: (ASN1
			read: self result result
			usingType: self operation resultType) ]
]

{ #category : #'as yet unclassified' }
ROSResult >> dispatchTo: aDialogue [ 
	aDialogue receivedReturn: self
]

{ #category : #'as yet unclassified' }
ROSResult >> hasResultType [
	^self operation resultType notNil
]

{ #category : #accessing }
ROSResult >> initializeFromDialogue: aDialogue [
	super initializeFromDialogue: aDialogue.
	self hasResultType ifTrue: [
		(map includesKey: 'result') ifTrue: [ self decodeResult ]]
]

{ #category : #accessing }
ROSResult >> result: anObject [
	| res val |

	anObject ifNotNil: [  
	self operation resultType ifNotNil: [  
		val := self operation resultType newValue: anObject.
		"anObject ifNotNil: [  
			anObject keysAndValuesDo: [ :key :v |
				val at: key put: v ] ]."
		res := self expandFieldNamed: 'result'.
		res at: 'result' put: val.
		(res expandFieldNamed: 'opcode') at: 'local' put: self operation operationCode ] ]
]

{ #category : #accessing }
ROSResult >> resultObject [
	^ (map at: 'result') at: 'result'
]
