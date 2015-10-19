# TextMagic ObjectPascal API Wrapper
Wrapper for the TextMagic REST API V2. It has been developed and tested in Delphi XE2 and XE7, but it should work in any modern version of Delphi.

# How to Install
You can clone the repo in your location of choice by using :
```sh
git clone https://github.com/textmagic/textmagic-rest-object-pascal.git
```
You can also manually clone the project, or simply download the files.
# Getting it running
You'll need to make sure these 3 files are accessible by your project, either by adding them directly to the project, or making them accessible through your library path.
- *TextmagicRestClient.pas* - The API wrapper itself.
- *XSuperJSON.pas* - Helper library for JSON Parsing
- *XSuperObject.pas* - Helper library for JSON Parsing

On your project you will only need to use the unit *TextmagicRestClient.pas*.

The wrapper uses Indy components to communicate with the REST API via SSL. In some cases, Indy will not be able to load the SSL libraries. If that happens, you can get them at [https://opendec.wordpress.com/tag/openssl/]. You'll just need to make sure the files **libeay32.dll** and **ssleay32.dll** (note: I'm using 32 bit versions) are accessible to your application.

That is all you need to start using the API.

# Using the API
The entire API is accessible via the class **TTMClient**, found in the **TextmagicRestClient.pas** file. You'll need to provide your credentials when creating the object. Check the TextMagic API documentation for up to date instructions on how to do that.
```Pascal
var TMC:TTMClient;
...
TMC := TTMClient.Create(Your_User_Name, Your_API_V2_Key);
```
The TTMClient's methods and parameters are very self-explanatory and for the most part they correspond directly to the API functions. Keep in mind most of the methods return an instance of a class, so don't forget to correctly free them to avoid memory leaks.
You'll note several of the methods return a **TTMLinkResult** class. This is a generic response for several of the API functions and contains the **id** of the created/updated resource and a direct link to the resource itself.
# A few examples
Getting your user account details :
```Pascal
var User:TTMUser;
...
User:=TMC.GetUser;
User.free;
```
Creating a new contact list:
```Pascal
var LinkResult:TTMLinkResult;
...
LinkResult:=TMC.CreateList('My new list');
{ LinkResult.Id will contain the ID of the newly created list } 
LinkResult.free;
```

Creating a new contact:
```Pascal
var LinkResult:TTMLinkResult;
...
{ A list id is mandatory for creating contacts }
LinkResult:=TMC.CreateContact('99911111337', MY_LIST_ID,'John','Doe');
{ LinkResult.Id will contain the ID of the newly created contact } 
LinkResult.free;
```
Sending a message to a single contact:
```Pascal
var MR:TTMMessageResult;
...
MR:=TMC.CreateMessage('My SMS message',null,null,MY_CONTACT_ID,null,null,null,null,null,null,null);
MR.free;
```
Sending a message to a list of contacts:
```Pascal
var MR:TTMMessageResult;
...
MR:=TMC.CreateMessage('My SMS message',null,null,null,MY_LIST_ID,null,null,null,null,null,null);
MR.free;
```

# Keywords

delphi sms api
delphi sms rest api
send text message from delphi
delphi sms http api
send sms message with delphi
send sms with delphi
send sms via delphi
sms gateway in delphi
send text message delphi
send sms message using delphi
send sms message through delphi
