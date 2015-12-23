Extension { #name : #DateAndTime }

{ #category : #'*ston-core' }
DateAndTime class >> fromSton: stonReader [
	^ self readFrom: stonReader parseListSingleton readStream
]

{ #category : #'*ston-core' }
DateAndTime >> stonContainSubObjects [ 
	^ false
]

{ #category : #'*ston-core' }
DateAndTime >> stonOn: stonWriter [
	"Use an ISO representation with all details"
	
	stonWriter writeObject: self listSingleton: 
		(String streamContents: [ :stream |
			self printOn: stream withLeadingSpace: false ])
]
