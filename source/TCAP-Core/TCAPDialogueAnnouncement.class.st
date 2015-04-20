Class {
	#name : #TCAPDialogueAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'dialogue'
	],
	#category : #'TCAP-Core-Announcements'
}

{ #category : #'as yet unclassified' }
TCAPDialogueAnnouncement class >> dialogue: aDialogue [
	^ self new
		dialogue: aDialogue
]

{ #category : #accessing }
TCAPDialogueAnnouncement >> dialogue [
	^ dialogue
]

{ #category : #accessing }
TCAPDialogueAnnouncement >> dialogue: anObject [
	dialogue := anObject
]

{ #category : #accessing }
TCAPDialogueAnnouncement >> doesNotUnderstand: aMessage [
	^ (dialogue respondsTo: aMessage selector) 
		ifTrue: [ aMessage sendTo: dialogue ]
		ifFalse: [ super doesNotUnderstand: aMessage  ]
]
