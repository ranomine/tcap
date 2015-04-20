Class {
	#name : #TCAPInvocationReceived,
	#superclass : #Announcement,
	#instVars : [
		'invocation',
		'dialogue'
	],
	#category : #'TCAP-Core-Announcements'
}

{ #category : #accessing }
TCAPInvocationReceived >> dialogue [
	^ dialogue
]

{ #category : #accessing }
TCAPInvocationReceived >> dialogue: anObject [
	dialogue := anObject
]

{ #category : #accessing }
TCAPInvocationReceived >> doesNotUnderstand: aMessage [
	^ (invocation  respondsTo: aMessage selector) 
		ifTrue: [ aMessage sendTo: invocation ]
		ifFalse: [ super doesNotUnderstand: aMessage  ]
]

{ #category : #accessing }
TCAPInvocationReceived >> invocation [
	^ invocation
]

{ #category : #accessing }
TCAPInvocationReceived >> invocation: anObject [
	invocation := anObject
]
