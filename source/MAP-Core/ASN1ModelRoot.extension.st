Extension { #name : #ASN1ModelRoot }

{ #category : #'*map-core' }
ASN1ModelRoot >> applicationContextForOperation: anOperation [ 
	^ (self applicationContextsForOperation: anOperation) 
		ifNotEmpty: [ :contexts| 
			(contexts size > 1) ifTrue: [ Error signal: 'multiple application contexts found' ].
			contexts associations first value ]
		ifEmpty: [  nil  ]
]

{ #category : #'*map-core' }
ASN1ModelRoot >> applicationContextForOperationNamed: aString [ 
	^ self applicationContextForOperation: (self typeNamed: aString)
]

{ #category : #'*map-core' }
ASN1ModelRoot >> applicationContextOidForOperationNamed: aString [ 
	^ (self applicationContextsForOperationNamed: aString)
		associations first value attributeAt: 'applicationContextName'
]

{ #category : #'*map-core' }
ASN1ModelRoot >> applicationContextWithOid: anOidOrString [
	modules do: [:module|
		(module applicationContextWithOid: anOidOrString asAsn1Oid) ifNotNil: [:context|
			^ context]].
	NotFound signal: 'application context with ', anOidOrString asString, ' not found'
]

{ #category : #'*map-core' }
ASN1ModelRoot >> applicationContexts [
	^ self objectsWithClass: 'APPLICATION-CONTEXT'
]

{ #category : #'*map-core' }
ASN1ModelRoot >> applicationContextsForOperation: anOperation [ 
	^ self applicationContexts select: [ :applicationContext|
		applicationContext includes: anOperation ]
]

{ #category : #'*map-core' }
ASN1ModelRoot >> applicationContextsForOperationNamed: aString [ 
	^ self applicationContextsForOperation: (self typeNamed: aString)
]

{ #category : #'*map-core' }
ASN1ModelRoot >> operationPackages [
	^ self objectsWithClass: 'OPERATION-PACKAGE'
]

{ #category : #'*map-core' }
ASN1ModelRoot >> operationPackagesForOperation: anOperation [ 
	^ self operationPackages select: [ :operationPackage|
		operationPackage includes: anOperation ]
]
