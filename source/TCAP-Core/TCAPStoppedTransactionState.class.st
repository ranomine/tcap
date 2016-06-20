"
Transaction is stopped. (The X case in Q.774)
"
Class {
	#name : #TCAPStoppedTransactionState,
	#superclass : #TCAPTransactionState,
	#category : #'TCAP-Core-State'
}

{ #category : #accessing }
TCAPStoppedTransactionState class >> label [
	^ #stopped
]

{ #category : #indications }
TCAPStoppedTransactionState >> receivedBegin: aBeginMessage [ 
	"just ignore"
]
