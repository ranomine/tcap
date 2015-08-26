Class {
	#name : #TCAPIdPool,
	#superclass : #Object,
	#instVars : [
		'size',
		'pool',
		'startValue'
	],
	#category : #'TCAP-Core-Model'
}

{ #category : #accessing }
TCAPIdPool >> allocate: aNumber [
	(pool includes: aNumber)  ifTrue: [ 
		 TCAPIdAlreadyAllocated signal: 'id ', aNumber asString,' is already allocated'].
	^ pool add: aNumber
]

{ #category : #accessing }
TCAPIdPool >> basicNextId [
	^ pool max + 1
]

{ #category : #accessing }
TCAPIdPool >> findAndAllocateFreedId [
	TCAPNoFreeId signal
]

{ #category : #accessing }
TCAPIdPool >> free: anId [
	"ids can be double freed because dialogue and transaction are
	sharing them"
	pool remove: anId ifAbsent: [ ] 
]

{ #category : #accessing }
TCAPIdPool >> freeByteArray: aByteArray [ 
	aByteArray ifNotNil: [  
		self free: aByteArray asInteger ]
]

{ #category : #accessing }
TCAPIdPool >> freeString: aString [
	aString ifNotNil: [  
		self free: (Number readFrom: aString base: 16) ]
]

{ #category : #testing }
TCAPIdPool >> hasIdsAllocated [
	^ pool notEmpty
]

{ #category : #testing }
TCAPIdPool >> hasMoreIds [
	^ pool size < size
]

{ #category : #'initialize-release' }
TCAPIdPool >> initialize [ 
	super initialize.
	pool := Set new: 10.
	startValue := 1.
]

{ #category : #accessing }
TCAPIdPool >> max [
	^ pool max
]

{ #category : #accessing }
TCAPIdPool >> nextId [
	| id |
	id := pool isEmpty
		ifTrue: [ startValue ] 
		ifFalse: [ self basicNextId ].
	^ (id <= size) 
		ifTrue: [  self allocate: id ]
		ifFalse: [ self findAndAllocateFreedId ]
]

{ #category : #'as yet unclassified' }
TCAPIdPool >> nextIdByteArray [
	^ self nextId asByteArray
]

{ #category : #accessing }
TCAPIdPool >> nextIdString [
	^ self nextId printStringHex
]

{ #category : #accessing }
TCAPIdPool >> noId [
	^ -1 
]

{ #category : #'as yet unclassified' }
TCAPIdPool >> poolSize [
	^pool size
]

{ #category : #accessing }
TCAPIdPool >> size [
	^ size
]

{ #category : #accessing }
TCAPIdPool >> size: anObject [
	size := anObject
]

{ #category : #accessing }
TCAPIdPool >> startValue: aNumber [ 
	startValue := aNumber
]
