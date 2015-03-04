Class {
	#name : #ROSError,
	#superclass : #ROSMessage,
	#instVars : [
		'error'
	],
	#category : #'ROS-Core'
}

{ #category : #accessing }
ROSError class >> asn1TypeName [
	^ 'ReturnError'
]

{ #category : #'instance creation' }
ROSError class >> dispatchInstanceCreationOn: aFactory [ 
	^ aFactory newROSError
]

{ #category : #'as yet unclassified' }
ROSError class >> isAsn1ModelClass [
	^ true
]

{ #category : #accessing }
ROSError class >> rosMessageType [
	^ 'returnError'
]

{ #category : #'as yet unclassified' }
ROSError >> decodeParameter [

	(map at: 'parameter' ifAbsent: [ ^ self ]) isAsn1TaggedValue ifTrue: [  
		map
			at: 'parameter'
			put: (ASN1
				read: self parameter
				usingType: self parameterType) ]
]

{ #category : #dispatching }
ROSError >> dispatchTo: aDialogue [ 
	aDialogue receivedError: self
]

{ #category : #accessing }
ROSError >> error [
	^ error
]

{ #category : #accessing }
ROSError >> error: anError [
	error := anError
]

{ #category : #accessing }
ROSError >> errorCode [
	^ (self at: 'errcode') at: 'local'
]

{ #category : #initialize }
ROSError >> initializeErrorCode [
	(self expandFieldNamed: 'errcode') at: 'local' put: (error attributeAt: 'errorCode')
]

{ #category : #resolving }
ROSError >> initializeFromDialogue: aDialogue [
	super initializeFromDialogue: aDialogue.
	error := aDialogue applicationContext findElement: [ :err | 
		err isError and: [ (err attributeAt: 'errorCode') = self errorCode ] ].
	self decodeParameter 
]

{ #category : #accessing }
ROSError >> name [
	^ error originalBindingName 
]

{ #category : #accessing }
ROSError >> normalizedOperationName [
	self flag: #todo.
	^ (self operationName copyWithout: $-) asSymbol asMutator.
]

{ #category : #accessing }
ROSError >> parameterType [
	^ self error attributeAt: 'ParameterType'
]

{ #category : #converting }
ROSError >> prepare [
	(self expandFieldNamed: 'errcode') at: 'local' put: (error attributeAt: 'errorCode').
]

{ #category : #accessing }
ROSError >> setParameter: aParameter [
	aParameter ifNil: [ ^ self ].
 	self at: 'parameter' put: (aParameter asAsn1Value type: self parameterType) 
]
