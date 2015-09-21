Class {
	#name : #TCAPBeforeMessageReceived,
	#superclass : #TCAPMessageAnnouncement,
	#category : #'TCAP-Core-Announcements'
}

{ #category : #'as yet unclassified' }
TCAPBeforeMessageReceived >> dispatchTo: aHandler [ 
	aHandler 
		perform: (#before, message messageType capitalized, #MessageReceived) asSymbol asMutator 
		with: self
]
