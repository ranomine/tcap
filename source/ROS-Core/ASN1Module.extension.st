Extension { #name : #ASN1Module }

{ #category : #'*ros-core' }
ASN1Module >> operationNamed: aString [
	^ (self operations associations 
		detect: [:each| each key = aString ]) value
]

{ #category : #'*ros-core' }
ASN1Module >> operations [
	^ (self allObjects select: [:each| each isOperation])
		select: [:each| (each attributeAt: 'operationCode') isNumber ]
]
