Class {
	#name : #TCAPTestTransaction,
	#superclass : #TCAPTransaction,
	#category : #'TCAP-Core-Tests-Model'
}

{ #category : #'as yet unclassified' }
TCAPTestTransaction >> switchToState: aSymbol [ 
	| stateClass |
	{ 'Transaction' -> self .
	   'Dialogue' -> self dialogue } do: [ :each | 
		stateClass := 'TCAP', aSymbol capitalized, each key, 'State'.
		each value perform: #nextState: with: (Smalltalk at: stateClass asSymbol) new
		 ]
]
