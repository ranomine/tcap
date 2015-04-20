Class {
	#name : #TCAPMessageAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'message',
		'dialogue'
	],
	#category : #'TCAP-Core-Announcements'
}

{ #category : #'as yet unclassified' }
TCAPMessageAnnouncement class >> message: aMessage dialogue: aDialogue [
	^ self new
		message: aMessage;
		dialogue: aDialogue
]

{ #category : #accessing }
TCAPMessageAnnouncement >> dialogue [
	^ dialogue
]

{ #category : #accessing }
TCAPMessageAnnouncement >> dialogue: anObject [
	dialogue := anObject
]

{ #category : #accessing }
TCAPMessageAnnouncement >> message [
	^ message
]

{ #category : #accessing }
TCAPMessageAnnouncement >> message: anObject [
	message := anObject
]
