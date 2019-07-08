"
This test case creates a class ExtendedClassForTests2 in a package ExtendedPackageForTests2. 
Another extension is created in a package ExtendingPackageForTests2 with a method #extensionMethod1 for that class. The importing package created in the parent test case also imports that extension.

"
Class {
	#name : #CreateConflictingExtensionMethod,
	#superclass : #CreateExtensionMethodSenders,
	#instVars : [
		'extension2',
		'extensionMethod2',
		'extendedClass2'
	],
	#category : #'ScopedExtensions-Tests'
}

{ #category : #running }
CreateConflictingExtensionMethod >> setUp [
	super setUp.
	extendedClass2 := Object subclass: #ExtendedClassForTests2 instanceVariableNames: '' classVariableNames: '' category: #ExtendedPackageForTests2.
	extension2 := Extension named: #ExtensionForTests2 packageNamed: #ExtendingPackageForTests2.
	extensionMethod2 := extension2 compileExtension: 'extensionMethod1 ^ #conflictingExtensionMethod' inBehavior: extendedClass2.
	self importingPackage1 import: extension2
]

{ #category : #running }
CreateConflictingExtensionMethod >> tearDown [
	extendedClass2 removeFromSystem.
	super tearDown
]

{ #category : #tests }
CreateConflictingExtensionMethod >> testObjectSendToConflictingMethodDispatchesToConflictingMethod [
	self assert: (importingClass1 new objectSend: extendedClass2 new) equals: #conflictingExtensionMethod
]

{ #category : #tests }
CreateConflictingExtensionMethod >> testObjectSendToExtensionClassDispatchesToExtensionMethod [
	self assert: (importingClass1 new objectSend: extendedClass1 new) equals: #extensionMethod1
]

{ #category : #tests }
CreateConflictingExtensionMethod >> testObjectSendToPolymorphicClassDispatchesToPolymorphicMethod [
	self assert: (importingClass1 new objectSend: polymorphicClass1 new) equals: #polymorphicMethod
]

{ #category : #tests }
CreateConflictingExtensionMethod >> testScopedSelectorForObjectSendIsForkSelector [
	| selector |
	self flag: #check. "bad test"
	selector := self importingPackage1 lookupScopedSelector: #extensionMethod1.
	self assert: (selector isKindOf: ForkSelector).
	self assertCollection: selector wrappedSelectors asIdentitySet equals: { extensionMethod1 selector. extensionMethod2 selector } asIdentitySet
]

{ #category : #tests }
CreateConflictingExtensionMethod >> testScopedSelectorForSelfSendIsScopedSelector [
	| selector |
	self flag: #check. "bad test"
	selector := self importingPackage1 lookupScopedSelector: #extensionMethod1 forBehavior: importingClass1.
	self assert: (selector isKindOf: ScopedSelector).
	self assert: selector == extensionMethod1 selector
]

{ #category : #tests }
CreateConflictingExtensionMethod >> testSelfSendDispatchesToExtensionMethod [
	self assert: importingClass1 new selfSend equals: #extensionMethod1
]
