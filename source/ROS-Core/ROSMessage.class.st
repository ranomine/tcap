Class {
	#name : #ROSMessage,
	#superclass : #ASN1AdaptiveTypeObject,
	#instVars : [
		'dialogue'
	],
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
	ros := (self asn1TypeNamed: 'ROS') newValue.
	(ros expandFieldNamed: self class rosMessageType)
		value: self.
	^ ros
]

{ #category : #accessing }
ROSMessage >> invokeId [
	^ (self at: 'invokeId') at: 'present'
]

{ #category : #accessing }
ROSMessage >> invokeId: aNumber [
	aNumber ifNil: [ Error signal: 'cannot use nil as invokeId' ].
	(self expandFieldNamed: 'invokeId')
		at: 'present' put: aNumber
]

{ #category : #accessing }
ROSMessage >> linkedId [
	^ (self at: 'linkedId') at: 'present'
]

{ #category : #accessing }
ROSMessage >> linkedId: aNumber [
	aNumber ifNil: [ Error signal: 'cannot use nil as linkedId' ].
	(self expandFieldNamed: 'linkedId')
		at: 'present' put: aNumber
]
