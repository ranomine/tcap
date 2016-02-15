"
A TCAPDialogueCreated signals that a  dialog was created locally. 

"
Class {
	#name : #TCAPDialogueCreated,
	#superclass : #TCAPDialogueAnnouncement,
	#category : #'TCAP-Core-Announcements'
}

{ #category : #accessing }
TCAPDialogueCreated >> onInvoke: aBlock [
	dialogue onInvoke: aBlock
]
