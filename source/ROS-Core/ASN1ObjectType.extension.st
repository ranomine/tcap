Extension { #name : #ASN1ObjectType }

{ #category : #'*ros-core' }
ASN1ObjectType >> isError [
	^ self clazz = 'ERROR'
]

{ #category : #'*ros-core' }
ASN1ObjectType >> isOperation [
	^ self clazz = 'OPERATION'
]

{ #category : #'*ros-core' }
ASN1ObjectType >> operationWithCode: aNumber [
	^ self findElement: [ :op | op isOperation and: [ (op attributeAt: 'operationCode') = aNumber ] ]
]
