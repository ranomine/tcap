Extension { #name : #TCAPServiceEndPoint }

{ #category : #'*Camel-SCF-Core' }
TCAPServiceEndPoint classSide >> newCamel [
	^ self new
		factory: SCFCamelObjectFactory new
]

{ #category : #'*Camel-SCF-Core' }
TCAPServiceEndPoint classSide >> newSCF [
	^ self new
		factory: SCFPhase1ObjectFactory new
]
