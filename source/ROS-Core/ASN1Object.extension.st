Extension { #name : #ASN1Object }

{ #category : #'*ros-core' }
ASN1Object >> isError [
	^ self clazz = 'ERROR'
]

{ #category : #'*ros-core' }
ASN1Object >> isOperation [
	^ self clazz = 'OPERATION'
]

{ #category : #'*ros-core' }
ASN1Object >> operationWithCode: aNumber [
	^ self findElement: [ :op | op isOperation and: [ (op attributeAt: 'operationCode') = aNumber ] ]
]
