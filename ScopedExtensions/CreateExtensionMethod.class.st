"
This test case creates a class ExtendedClassForTests1 in a package ExtendedPackageForTests1. Then it creates an extension ExtensionForTests1 in a package ExtendingPackageForTests1 and compile an extension method #extensionMethod1 for the class ExtendedClassForTests1.
"
Class {
	#name : #CreateExtensionMethod,
	#superclass : #TestCase,
	#instVars : [
		'extendedClass1',
		'extension1',
		'extensionMethod1'
	],
	#category : #'ScopedExtensions-Tests'
}

{ #category : #accessing }
CreateExtensionMethod >> extendingPackage1 [
	^ self packageNamed: #ExtendingPackageForTests1
]

{ #category : #accessing }
CreateExtensionMethod >> packageNamed: aSymbol [
	^ RPackageOrganizer default packageNamed: aSymbol
]

{ #category : #running }
CreateExtensionMethod >> setUp [
	extendedClass1 := Object subclass: #ExtendedClassForTests1 instanceVariableNames: '' classVariableNames: '' category: #ExtendedPackageForTests1.
	extension1 := Extension named: #ExtensionForTests1 packageNamed: #ExtendingPackageForTests1.
	extensionMethod1 := extension1 compileExtension: 'extensionMethod1 ^ #extensionMethod1' inBehavior: extendedClass1.
]

{ #category : #running }
CreateExtensionMethod >> tearDown [
	extendedClass1 removeFromSystem.
	(self packageNamed: #ExtendedPackageForTests1) unregister.
	(self packageNamed: #ExtendingPackageForTests1) unregister.
]

{ #category : #tests }
CreateExtensionMethod >> testExtensionIncludesExtensionMethod [
	self assert: (extension1 definesMethodNamed: #extensionMethod1 inBehavior: extendedClass1)
]

{ #category : #tests }
CreateExtensionMethod >> testExtensionIncludesPackage [
	self assert: extension1 package equals: self extendingPackage1
]

{ #category : #tests }
CreateExtensionMethod >> testExtensionMethodIsInstalledInExtendedClass [
	self assert: (extendedClass1 methodDictionary values includes: extensionMethod1)
]

{ #category : #tests }
CreateExtensionMethod >> testExtensionMethodSelecorIsScoped [
	self assert: (extensionMethod1 selector isKindOf: ScopedSelector).
	self assert: (extensionMethod1 selector wrappedSymbol = #extensionMethod1)
]

{ #category : #tests }
CreateExtensionMethod >> testPackageIncludesExtension1 [
	self assert: (self extendingPackage1 extensions includes: extension1).
	self assert: (self extendingPackage1 includesClass: extension1)
]
