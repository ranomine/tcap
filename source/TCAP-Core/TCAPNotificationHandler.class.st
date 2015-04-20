Class {
	#name : #TCAPNotificationHandler,
	#superclass : #Object,
	#category : #'TCAP-Core-Handler'
}

{ #category : #'instance creation' }
TCAPNotificationHandler class >> registerAt: aServiceEndPoint [
	self subclassResponsibility
]

{ #category : #registering }
TCAPNotificationHandler >> registerAtDialogue: anAnnouncer [

]

{ #category : #'as yet unclassified' }
TCAPNotificationHandler >> registerAtServicePoint: anAnnouncer [
]
