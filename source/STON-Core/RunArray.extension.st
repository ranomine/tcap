Extension { #name : #RunArray }

{ #category : #'*ston-core' }
RunArray class >> fromSton: stonReader [
	^ self new
		fromSton: stonReader;
		yourself
]

{ #category : #'*ston-core' }
RunArray >> fromSton: stonReader [
	stonReader parseNamedInstVarsFor: self
]

{ #category : #'*ston-core' }
RunArray >> stonOn: stonWriter [
	stonWriter writeObject: self
]
