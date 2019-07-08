"
This test case creates a subclass of ExtendedClassForTests1 named ImportingClassForTests1 in package ImportingPackageForTests1. This importing package imports the extension defined in the parent test case. It then compiles two methods in that subclass #objectSend: and #selfSend. These methods send #extensionMethod1 to the argument and self respectively. 

This test case also creates a class PolymorphicClassForTests1 that also implement a method with the same selector than the extension method created in the parent test case. This class is used to verify that polymorphism works correctly in case of object sends.
"
Class {
	#name : #CreateExtensionMethodSenders,
	#superclass : #CreateExtensionMethod,
	#instVars : [
		'importingClass1',
		'polymorphicClass1'
	],
	#category : #'ScopedExtensions-Tests'
}

{ #category : #accessing }
CreateExtensionMethodSenders >> importingPackage1 [
	^ self packageNamed: #ImportingPackageForTests1
]

{ #category : #running }
CreateExtensionMethodSenders >> setUp [ 
	super setUp.
	importingClass1 := extendedClass1 subclass: #ImportingClassForTests1 instanceVariableNames: '' classVariableNames: '' category: #ImportingPackageForTests1.
	importingClass1 compile: 'objectSend: o ^ o extensionMethod1'.
	importingClass1 compile: 'selfSend ^ self extensionMethod1'.
	self importingPackage1 import: extension1.
	polymorphicClass1 := Object subclass: #PolymorphicClassForTests1 instanceVariableNames: '' classVariableNames: '' category: #PolymorphicPackageForTests1.
	polymorphicClass1 compile: 'extensionMethod1 ^ #polymorphicMethod'
]

{ #category : #running }
CreateExtensionMethodSenders >> tearDown [
	importingClass1 removeFromSystem.
	(self packageNamed: #ImportingPackageForTests1) unregister.
	polymorphicClass1 removeFromSystem.
	(self packageNamed: #PolymorphicPackageForTests1) unregister.
	super tearDown
]

{ #category : #tests }
CreateExtensionMethodSenders >> testImportingPackageImportsExtension [
	self assert: (self importingPackage1 imports includes: extension1).
	self assert: (extension1 isImportedBy: self importingPackage1)
]

{ #category : #tests }
CreateExtensionMethodSenders >> testObjectSendToExtensionClassDispatchesToExtensionMethod [
	self assert: (importingClass1 new objectSend: extendedClass1 new) equals: #extensionMethod1
]

{ #category : #tests }
CreateExtensionMethodSenders >> testObjectSendToPolymorphicClassDispatchesToPolymorphicMethod [
	self assert: (importingClass1 new objectSend: polymorphicClass1 new) equals: #polymorphicMethod
]

{ #category : #tests }
CreateExtensionMethodSenders >> testSelfSendDispatchesToExtensionMethod [
	self assert: importingClass1 new selfSend equals: #extensionMethod1
]

{ #category : #tests }
CreateExtensionMethodSenders >> testSymbolScopedSelectorMapping [
	self assert: (self importingPackage1 lookupScopedSelector: #extensionMethod1) == extensionMethod1 selector
]
