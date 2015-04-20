Class {
	#name : #TCAPAfterMessageReceived,
	#superclass : #TCAPMessageAnnouncement,
	#category : #'TCAP-Core-Announcements'
}

{ #category : #dispatching }
TCAPAfterMessageReceived >> dispatchTo: aHandler [ 
	aHandler 
		perform: (#after, message class type capitalized, #MessageReceived) asSymbol asMutator 
		with: self
]
