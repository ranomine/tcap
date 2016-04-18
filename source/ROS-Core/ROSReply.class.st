Class {
	#name : #ROSReply,
	#superclass : #ROSMessage,
	#instVars : [
		'invocation'
	],
	#category : #'ROS-Core'
}

{ #category : #accessing }
ROSReply >> initializeFromDialogue: aDialogue [
	invocation := aDialogue localInvocationWithId: self invokeId.
	invocation ifNotNil: [invocation dialogue: aDialogue].
	
]

{ #category : #accessing }
ROSReply >> invocation [
	^ invocation
]

{ #category : #accessing }
ROSReply >> invocation: anObject [
	invocation := anObject
]

{ #category : #accessing }
ROSReply >> operation [
	^ invocation operation
]

{ #category : #accessing }
ROSReply >> operationName [
	^ invocation operationName
]
