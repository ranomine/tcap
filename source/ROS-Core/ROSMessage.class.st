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
ROSMessage class >> withMessageType: aString [ 
	^ self allSubclasses
		detect: [ :cls |
			cls rosMessageType =  aString  ]
]

{ #category : #converting }
ROSMessage >> asROS [
	| ros |
	self prepare.
	"self validate."
	ros := (self asn1TypeNamed: 'ROS') newValue.
	(ros expandFieldNamed: self class rosMessageType)
		value: self.
	^ ros
]

{ #category : #accessing }
ROSMessage >> id [
	self halt.
	^ (self at: 'invokeId') at: 'present'
]

{ #category : #accessing }
ROSMessage >> id: aNumber [
	self halt.
	aNumber ifNil: [ self halt ].
	(self expandFieldNamed: 'invokeId')
		at: 'present' put: aNumber
]

{ #category : #accessing }
ROSMessage >> initializeFromDialogue: aDialogue [
	parent := aDialogue localInvocationWithId: self invokeId.

]

{ #category : #accessing }
ROSMessage >> invokeId [
	^ (self at: 'invokeId') at: 'present'
]

{ #category : #accessing }
ROSMessage >> invokeId: aNumber [
	aNumber ifNil: [ self halt ].
	(self expandFieldNamed: 'invokeId')
		at: 'present' put: aNumber
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
