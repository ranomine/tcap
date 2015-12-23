Extension { #name : #Class }

{ #category : #'*STON-Core' }
Class class >> fromSton: stonReader [
	^ stonReader parseListSingleton asClass
]
