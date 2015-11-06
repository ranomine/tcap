Class {
	#name : #ROSResult,
	#superclass : #ROSReply,
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

	self result result isAsn1EncodedValue ifTrue: [  
		self hasResultType ifFalse: [ 
			ROSInvocationError signal: 'decoding ', self class name,' failed because operation ', self operationName,'  has no resultType ' ].
		self result privAt: 'result' put: (ASN1
			read: self result result
			usingType: self resultType) ]
]

{ #category : #'as yet unclassified' }
ROSResult >> dispatchTo: aDialogue [ 
	aDialogue receivedReturn: self
]

{ #category : #'as yet unclassified' }
ROSResult >> hasResultType [
	^self resultType notNil
]

{ #category : #accessing }
ROSResult >> initializeFromDialogue: aDialogue [
	super initializeFromDialogue: aDialogue.
	self hasResultType ifTrue: [
		(map includesKey: 'result') ifTrue: [ self decodeResult ]]
]

{ #category : #accessing }
ROSResult >> result: anObject [
	| res |

	anObject ifNotNil: [  
	self operation resultType ifNotNil: [  
		res := self expandFieldNamed: 'result'.
		(res expandFieldNamed: 'result') contents: anObject.
		(res expandFieldNamed: 'opcode') privAt: 'local' put: self operation operationCode ] ]
]

{ #category : #accessing }
ROSResult >> resultObject [
	^ (map at: 'result') at: 'result'
]

{ #category : #accessing }
ROSResult >> resultType [
	^ self operation resultType
]
