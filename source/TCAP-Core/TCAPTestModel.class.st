Class {
	#name : #TCAPTestModel,
	#superclass : #ASN1TestModel,
	#category : #'TCAP-Core-Tests'
}

{ #category : #'as yet unclassified' }
TCAPTestModel class >> libraryNames [
	^ {TCAPModuleLibrary . 
		 ROSModuleLibrary .
		 MAPModuleLibrary  }
]
