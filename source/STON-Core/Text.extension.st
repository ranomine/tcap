Extension { #name : #Text }

{ #category : #'*ston-core' }
Text >> fromSton: stonReader [
	stonReader parseNamedInstVarsFor: self
]

{ #category : #'*ston-core' }
Text class >> fromSton: stonReader [
	^ self new
		fromSton: stonReader;
		yourself
]

{ #category : #'*ston-core' }
Text >> stonOn: stonWriter [
	stonWriter writeObject: self
]
