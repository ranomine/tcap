"
A TCAPDialogueReceived signalises that a Dialog has been created by a new Begin

The dialog was created from a remote invoke.

TCAPDialogueReceived is *not* signalled for every received dialogportion but just the first one (BEGIN).
"
Class {
	#name : #TCAPDialogueReceived,
	#superclass : #TCAPDialogueAnnouncement,
	#category : #'TCAP-Core-Announcements'
}

{ #category : #accessing }
TCAPDialogueReceived >> onInvoke: aBlock [
	dialogue onInvoke: aBlock
]
