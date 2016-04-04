Class {
	#name : #ROSError,
	#superclass : #ROSReply,
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

	(map at: 'parameter' ifAbsent: [ ^ self ]) contents isAsn1EncodedValue ifTrue: [  
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

{ #category : #accessing }
ROSError >> errorCode: aNumber [
	^ (self expandFieldNamed: 'errcode') privAt: 'local' put: aNumber
]

{ #category : #resolving }
ROSError >> initializeFromDialogue: aDialogue [
	super initializeFromDialogue: aDialogue.
	error := aDialogue applicationContext findElement: [ :err | 
		err isError and: [ (err attributeAt: 'errorCode') contents = self errorCode ] ].
	error ifNil: [ invocation returnReject: 2r00000011 type: 'returnError'.  aDialogue requestTcContinue.].
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

{ #category : #accessing }
ROSError >> setParameter: aParameter [
	aParameter ifNil: [ Error signal: 'cannot use nil as a parameter' ].
 	(self expandFieldNamed: 'parameter') contents: aParameter
]
