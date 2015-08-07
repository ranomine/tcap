Class {
	#name : #ROSMessage,
	#superclass : #ASN1AdaptiveTypeObject,
	#category : #'ROS-Core'
}

{ #category : #'instance creation' }
ROSMessage class >> fromComponent: anASN1Dictionary [ 
	| type |
	type := anASN1Dictionary keys first.
	^ (self withMessageType: type)
			new initializeFrom: (anASN1Dictionary at: type)
]

{ #category : #'instance creation' }
ROSMessage class >> newIn: aContext [
	^ self new 	
		type: (aContext typeNamed: self asn1TypeName) 
]

{ #category : #'instance creation' }
ROSMessage class >> withMessageType: aString [ 
	^ self allSubclasses
		detect: [ :cls |
			cls rosMessageType =  aString  ]
]

{ #category : #converting }
ROSMessage >> asROS [
	self prepare.
	"self validate."
	^ ROS new 
		type: (self asn1TypeNamed: 'ROS');
		at: self class rosMessageType put: self;
		yourself
]

{ #category : #accessing }
ROSMessage >> id [
	^ (self at: 'invokeId') at: 'present'
]

{ #category : #accessing }
ROSMessage >> id: aNumber [
	aNumber ifNil: [ self halt ].
	(self expandFieldNamed: 'invokeId')
		at: 'present' put: aNumber
]

{ #category : #accessing }
ROSMessage >> initializeFromDialogue: aDialogue [
	parent := aDialogue localInvocationWithId: self invokeId present.

]

{ #category : #accessing }
ROSMessage >> operation [
	^ parent operation
]

{ #category : #accessing }
ROSMessage >> operationName [
	^ parent operationName
]

{ #category : #actions }
ROSMessage >> prepare [
]

{ #category : #accessing }
ROSMessage >> setTypeFromParent: anObject [
	type := anObject elementAt: self class rosMessageType 
]
