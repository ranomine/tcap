Extension { #name : #ClassDescription }

{ #category : #'*STON-Core' }
ClassDescription >> stonContainSubObjects [
	^ false
]

{ #category : #'*STON-Core' }
ClassDescription >> stonOn: stonWriter [
	stonWriter writeObject: self listSingleton: self name asSymbol
]
