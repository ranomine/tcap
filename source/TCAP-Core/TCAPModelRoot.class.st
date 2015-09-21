Class {
	#name : #TCAPModelRoot,
	#superclass : #Object,
	#instVars : [
		'applicationContexts',
		'objectsByClass',
		'applicationContextByOid',
		'applicationContextByOperation',
		'asn1Model'
	],
	#category : #'TCAP-Core-Model'
}

{ #category : #'as yet unclassified' }
TCAPModelRoot class >> on: anASN1ModelRoot [ 
	^ self new
		initializeFromModelRoot: anASN1ModelRoot 
]

{ #category : #'as yet unclassified' }
TCAPModelRoot >> allOperations [
	^asn1Model allOperations
]

{ #category : #accessing }
TCAPModelRoot >> applicationContextForOperation: anOperation [
	^ applicationContexts 
		at: anOperation 
		ifAbsentPut: [ asn1Model applicationContextForOperation: anOperation ] 
]

{ #category : #'as yet unclassified' }
TCAPModelRoot >> applicationContextOidForOperationNamed: aString [ 
	^ asn1Model applicationContextOidForOperationNamed: aString
]

{ #category : #accessing }
TCAPModelRoot >> applicationContextWithOid: anOid [
	^ applicationContextByOid  
		at: anOid
		ifAbsentPut: [ asn1Model applicationContextWithOid: anOid ]
]

{ #category : #delegating }
TCAPModelRoot >> applicationContexts [
	^ asn1Model applicationContexts
]

{ #category : #accessing }
TCAPModelRoot >> applicationContextsForOperation: anOperation [
	^ applicationContextByOperation 
		at: anOperation 
		ifAbsentPut: [ asn1Model applicationContextsForOperation: anOperation ]
]

{ #category : #delegating }
TCAPModelRoot >> applicationContextsForOperationNamed: aString [ 
	^ asn1Model applicationContextsForOperationNamed: aString 
]

{ #category : #converting }
TCAPModelRoot >> asTcapModelRoot [
	^ self
]

{ #category : #'as yet unclassified' }
TCAPModelRoot >> configureModel [
	| col |
	col := OrderedCollection new.
	{ 'TCAP-Core' . 'ROS-Core' } do: [ :name | 
		(((RPackage organizer packageNamed: name) classes 
			select: [ :each | each inheritsFrom: ASN1BasicObject ])
			select: [ :each | each isAsn1ModelClass ]) collect: [ :cls |
				col add: (cls asn1TypeName -> cls asn1InstanceFactory) ] ].
	col.

	asn1Model applyMapping: col asDictionary

]

{ #category : #initialization }
TCAPModelRoot >> initialize [
	super initialize.
	applicationContextByOid  := Dictionary new. 
	applicationContextByOperation   := Dictionary new.
	objectsByClass := IdentityDictionary new. 
	applicationContexts := Dictionary new
]

{ #category : #'as yet unclassified' }
TCAPModelRoot >> initializeFromModelRoot: aModelRoot [
	asn1Model := aModelRoot.
	self configureModel.
]

{ #category : #delegating }
TCAPModelRoot >> moduleDefiningOid: aString [ 
	^ asn1Model moduleDefiningOid: aString
]

{ #category : #delegating }
TCAPModelRoot >> moduleNamed: aString [ 
	^ asn1Model moduleNamed: aString
]

{ #category : #accessing }
TCAPModelRoot >> objectsWithClass: aString [
	^ objectsByClass 
		at: aString asSymbol
		ifAbsentPut: [ asn1Model objectsWithClass: aString ]
]

{ #category : #'as yet unclassified' }
TCAPModelRoot >> reset [
	super reset.
	applicationContextByOid  := Dictionary new.
	applicationContextByOperation   := Dictionary new.
	objectsByClass := IdentityDictionary new. 
]

{ #category : #delegating }
TCAPModelRoot >> resolveOidsWhile: aBlock [
	^ asn1Model resolveOidsWhile: aBlock
]

{ #category : #delegation }
TCAPModelRoot >> typeNamed: aString [ 
	^ asn1Model typeNamed: aString
]
