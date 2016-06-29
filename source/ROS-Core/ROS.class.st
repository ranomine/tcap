Class {
	#name : #ROS,
	#superclass : #ASN1AdaptiveTypeObject,
	#category : #'ROS-Core'
}

{ #category : #accessing }
ROS class >> asn1TypeName [
	^ 'ROS'
]

{ #category : #accessing }
ROS >> message [
	^ map values first
]
