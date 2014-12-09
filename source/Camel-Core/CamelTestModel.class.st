Class {
	#name : #CamelTestModel,
	#superclass : #ASN1TestModel,
	#category : #'Camel-Core'
}

{ #category : #'as yet unclassified' }
CamelTestModel class >> libraryNames [
	^ {
		CamelModuleLibrary .
		TCAPModuleLibrary . 
		 ROSModuleLibrary .
		 MAPModuleLibrary }
]
