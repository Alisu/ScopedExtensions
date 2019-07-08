"
This test case remove the extension method created in the root test case.
"
Class {
	#name : #RemoveExtensionMethod,
	#superclass : #CreateExtensionMethodSenders,
	#category : #'ScopedExtensions-Tests'
}

{ #category : #'as yet unclassified' }
RemoveExtensionMethod >> setUp [	
	super setUp.
	extension1 removeMethodNamed: #extensionMethod1 fromBehavior: extendedClass1.
]

{ #category : #tests }
RemoveExtensionMethod >> testObjectSendToExtensionClassFails [
	self should: [ importingClass1 new objectSend: extendedClass1 new ] raise: MessageNotUnderstood
]

{ #category : #tests }
RemoveExtensionMethod >> testObjectSendToPolymorphicClassDispatchesToPolymorphicMethod [
	self assert: (importingClass1 new objectSend: polymorphicClass1 new) equals: #polymorphicMethod
]

{ #category : #tests }
RemoveExtensionMethod >> testSelfSendNotUnderstood [
	self should: [ importingClass1 new selfSend ] raise: MessageNotUnderstood
]

{ #category : #tests }
RemoveExtensionMethod >> testSymbolScopedSelectorMappingFailsbackToSymbol [
	"This ensures that the scoped selector has been deleted from the extension"
	self assert: (self importingPackage1 lookupScopedSelector: #extensionMethod1) == #extensionMethod1
]
