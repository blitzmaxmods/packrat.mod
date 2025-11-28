
# How to use this library

Verbosity can be:

0 is Quiet
1 is normal
2 is detailed (Not implemented)


# Running a unitest from the CLI

**Linux**

./unittest 00.UnitTest-Example

**Windows**

unittest 00.UnitTest-Example

# Available asserts

| Method | Types | Purpose |
|--------|---------|---|
| AssertEqual( condition:Int, expected:Int ) | Float, Int, String | Test for equality |
| AssertNotEqual( condition:Int, expected:Int ) | Int | Test for inequality |
| AssertTrue( condition:Int ) | Int | Test for True |
| AssertFalse( condition:Int ) | Int | Test for False |
| AssertNull( obj:object ) | Object | Test for NULL |
| AssertNotNull( obj:object ) | Object | Test for Not NULL |
| AssertType( obj:object, expected:string, matchcase:int=False ) | Object | Test object is a specific type |
| AssertNotType( obj:object, expected:string, matchcase:int=False ) | Object | Test object is not a specific type |

# Options
| Method | Purpose |
|--------|-----|
| Fail( reason:string ) | Force a failure with a specific reason |
| skip( reason:string ) | Forces the test to be skipped |
| skipIf( condition:int, reason:string ) | Forces the test to be skipped if condition is true |
| skipUnless( condition:int, reason:string ) | Forces the test to be skipped if condition is false |

