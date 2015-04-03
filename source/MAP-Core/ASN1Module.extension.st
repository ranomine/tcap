Extension { #name : #ASN1Module }

{ #category : #'*map-core' }
ASN1Module >> applicationContextWithOid: anOid [
	^ self applicationContexts
		detect: [: each | (each attributeAt: 'applicationContextName') = anOid ]
		ifNone: [ nil ]
]

{ #category : #'*map-core' }
ASN1Module >> applicationContexts [ 
	^ self allObjectsWithClass: 'APPLICATION-CONTEXT'
]
