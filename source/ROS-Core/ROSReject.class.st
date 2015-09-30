Class {
	#name : #ROSReject,
	#superclass : #ROSReply,
	#instVars : [
		'problem'
	],
	#category : #'ROS-Core'
}

{ #category : #'initailize-release' }
ROSReject class >> asn1TypeName [
	^ 'Reject'
]

{ #category : #'instance creation' }
ROSReject class >> dispatchInstanceCreationOn: aFactory [ 
	^ aFactory newROSReject
]

{ #category : #'as yet unclassified' }
ROSReject class >> isAsn1ModelClass [
	^ true
]

{ #category : #accessing }
ROSReject class >> rosMessageType [
	^ 'reject'
]

{ #category : #'as yet unclassified' }
ROSReject >> dispatchTo: aDialogue [ 
	aDialogue receivedReject: self 
]

{ #category : #'as yet unclassified' }
ROSReject >> prepare [
	(self expandFieldNamed: 'problem') 
		at: 'general' put: 1
]

{ #category : #accessing }
ROSReject >> problemKind [
	^ problem keys first
]

{ #category : #accessing }
ROSReject >> problemType [
	^ (problem type elementAt: self problemKind) value type.
]

{ #category : #accessing }
ROSReject >> reason [
	^ (self problemType namedNumbers at: self reasonIndex asNumber) name.
]

{ #category : #accessing }
ROSReject >> reasonIndex [
	^ problem values first
]

{ #category : #accessing }
ROSReject >> type [
	^ self problemKind
]
