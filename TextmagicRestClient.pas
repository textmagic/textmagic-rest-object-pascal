unit TextmagicRestClient;

/// This file is part of the TextmagicRestClient package.
///
/// Copyright (c) 2015 TextMagic Ltd. All rights reserved.
///
/// For the full copyright and license information, please view the LICENSE
/// file that was distributed with this source code.

/// autor Denis <denis@textmagic.biz>

interface

uses
  System.SysUtils,
  Variants,
  Classes,
  System.Generics.Collections,
  XSuperObject,
  IdGlobalProtocols,
  IdBaseComponent,
  IdComponent,
  IdTCPConnection,
  IdTCPClient,
  IdHTTP,
  IdSSL,
  IdSSLOpenSSL,
  DateUtils;

type
/// <summary>
///   User statement model
/// </summary>
TTMStatement = class
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('userId')]
  UserId : Integer;
  [ALIAS('date')]
  Date : TDateTime;
  [ALIAS('balance')]
  Balance : Real;
  [ALIAS('delta')]
  Delta : Integer;
  [ALIAS('type')]
  StatementType : String;
  [ALIAS('value')]
  Value : String;
  [ALIAS('comment')]
  Comment : String;
end;

/// <summary>
///   User statement model list
/// </summary>
TTMStatementList = class
  [ALIAS('page')]
  Page : Integer;
  [ALIAS('limit')]
  Limit : Integer;
  [ALIAS('pageCount')]
  PageCount : Integer;
  [ALIAS('resources')]
  Resources : TObjectList<TTMStatement>;
end;

/// <summary>
///   Timezone model
/// </summary>
TTMTimezone = class
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('area')]
  Area : String;
  [ALIAS('dst')]
  Dst : Integer;
  [ALIAS('offset')]
  Offset : Integer;
  [ALIAS('timezone')]
  Timezone : String;
end;

/// <summary>
///   Currency model
/// </summary>
TTMCurrency = class
  [ALIAS('id')]
  Id : String;
  [ALIAS('htmlSymbol')]
  HtmlSymbol : String;
end;

/// <summary>
///   User model
/// </summary>
TTMUser = class
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('username')]
  Username : String;
  [ALIAS('firstName')]
  FirstName : String;
  [ALIAS('lastName')]
  LastName : String;
  [ALIAS('status')]
  Status : String;
  [ALIAS('balance')]
  Balance : Real;
  [ALIAS('company')]
  Company : String;
  [ALIAS('currency')]
  Currency : TTMCurrency;
  [ALIAS('timezone')]
  Timezone : TTMTimezone;
  [ALIAS('subaccountType')]
  SubaccountType : String;
end;

/// <summary>
///   User model list
/// </summary>
TTMUserList = class
  [ALIAS('page')]
  Page : Integer;
  [ALIAS('limit')]
  Limit : Integer;
  [ALIAS('pageCount')]
  PageCount : Integer;
  [ALIAS('resources')]
  Resources : TObjectList<TTMUser>;
end;

/// <summary>
///   Sender ID model
/// </summary>
TTMSenderId = class
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('senderId')]
  SenderId : String;
  [ALIAS('user')]
  User : TTMUser;
  [ALIAS('status')]
  Status : String;
end;

/// <summary>
///   Sender ID model list
/// </summary>
TTMSenderIdList = class
  [ALIAS('page')]
  Page : Integer;
  [ALIAS('limit')]
  Limit : Integer;
  [ALIAS('pageCount')]
  PageCount : Integer;
  [ALIAS('resources')]
  Resources : TObjectList<TTMSenderId>;
end;

/// <summary>
///   Country model
/// </summary>
TTMCountry = class
  [ALIAS('id')]
  Id : String;
  [ALIAS('name')]
  Name : String;
end;

/// <summary>
///   User dedicated number model
/// </summary>
TTMNumber = class
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('user')]
  User : TTMUser;
  [ALIAS('purchasedAt')]
  PurchasedAt : TDateTime;
  [ALIAS('expireAt')]
  ExpireAt : TDateTime;
  [ALIAS('phone')]
  Phone : String;
  [ALIAS('country')]
  Country : TTMCountry;
  [ALIAS('status')]
  Status : String;
end;

/// <summary>
///   User dedicated number model list
/// </summary>
TTMNumberList = class
  [ALIAS('page')]
  Page : Integer;
  [ALIAS('limit')]
  Limit : Integer;
  [ALIAS('pageCount')]
  PageCount : Integer;
  [ALIAS('resources')]
  Resources : TObjectList<TTMNumber>;
end;

/// <summary>
///   Dedicated number available list model
/// </summary>
TTMAvailableNumberList = class
  [ALIAS('numbers')]
  Numbers : TStringList;
  [ALIAS('price')]
  Price : Real;
  public
    constructor Create;
    destructor Destroy;
end;

/// <summary>
///   User sources list model
/// </summary>
TTMSources = class
  [ALIAS('dedicated')]
  Dedicated : TStringList;
  [ALIAS('shared')]
  Shared : TStringList;
  [ALIAS('senderIds')]
  SenderIds : TStringList;
  public
    constructor Create;
    destructor Destroy;
end;

/// <summary>
///   Invoice model
/// </summary>
TTMInvoice = class
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('bundle')]
  Bundle : Integer;
  [ALIAS('currency')]
  Currency : String;
  [ALIAS('vat')]
  Vat : Integer;
  [ALIAS('paymentMethod')]
  PaymentMethod : String;
end;

/// <summary>
///   Invoice model list
/// </summary>
TTMInvoiceList = class
  [ALIAS('page')]
  Page : Integer;
  [ALIAS('limit')]
  Limit : Integer;
  [ALIAS('pageCount')]
  PageCount : Integer;
  [ALIAS('resources')]
  Resources : TObjectList<TTMInvoice>;
end;

/// <summary>
///   Reply model
/// </summary>
TTMReply = class
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('sender')]
  Sender : String;
  [ALIAS('messageTime')]
  MessageTime : TDateTime;
  [ALIAS('text')]
  Text : String;
  [ALIAS('receiver')]
  Receiver : String;
end;

/// <summary>
///   Reply model list
/// </summary>
TTMReplyList = class
  [ALIAS('page')]
  Page : Integer;
  [ALIAS('limit')]
  Limit : Integer;
  [ALIAS('pageCount')]
  PageCount : Integer;
  [ALIAS('resources')]
  Resources : TObjectList<TTMReply>;
end;

/// <summary>
///   Message session model
/// </summary>
TTMSession = class
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('startTime')]
  StartTime : TDateTime;
  [ALIAS('text')]
  Text : String;
  [ALIAS('source')]
  Source : String;
  [ALIAS('referenceId')]
  ReferenceId : String;
  [ALIAS('price')]
  Price : Real;
  [ALIAS('numbersCount')]
  NumbersCount : Integer;
end;

/// <summary>
///   Message session model list
/// </summary>
TTMSessionList = class
  [ALIAS('page')]
  Page : Integer;
  [ALIAS('limit')]
  Limit : Integer;
  [ALIAS('pageCount')]
  PageCount : Integer;
  [ALIAS('resources')]
  Resources : TObjectList<TTMSession>;
end;

/// <summary>
///   Schedule message model
/// </summary>
TTMSchedule = class
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('nextSend')]
  NextSend : TDateTime;
  Session : TTMSession;
  [ALIAS('rrule')]
  Rrule : String;
end;

/// <summary>
///   Schedule message model list
/// </summary>
TTMScheduleList = class
  [ALIAS('page')]
  Page : Integer;
  [ALIAS('limit')]
  Limit : Integer;
  [ALIAS('pageCount')]
  PageCount : Integer;
  [ALIAS('resources')]
  Resources : TObjectList<TTMSchedule>;
end;

/// <summary>
///   Bulk message session model
/// </summary>
TTMBulkSession = class
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('status')]
  Status : String;
  [ALIAS('itemsProcessed')]
  ItemsProcessed : Integer;
  [ALIAS('itemsTotal')]
  ItemsTotal : Integer;
  [ALIAS('createdAt')]
  CreatedAt : TDateTime;
  Session : TTMSession;
  [ALIAS('text')]
  Text : String;
end;

/// <summary>
///   Bulk message session model list
/// </summary>
TTMBulkSessionList = class
  [ALIAS('page')]
  Page : Integer;
  [ALIAS('limit')]
  Limit : Integer;
  [ALIAS('pageCount')]
  PageCount : Integer;
  [ALIAS('resources')]
  Resources : TObjectList<TTMBulkSession>;
end;

/// <summary>
///   Message model
/// </summary>
TTMMessage = class
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('receiver')]
  Receiver : String;
  [ALIAS('messageTime')]
  MessageTime : TDateTime;
  [ALIAS('status')]
  Status : String;
  [ALIAS('text')]
  Text : String;
  [ALIAS('charset')]
  Charset : String;
  [ALIAS('firstName')]
  FirstName : String;
  [ALIAS('lastName')]
  LastName : String;
  [ALIAS('country')]
  Country : String;
  [ALIAS('sender')]
  Sender : String;
  [ALIAS('price')]
  Price : Real;
  [ALIAS('partsCount')]
  PartsCount : Integer;
end;

/// <summary>
///   Message model list
/// </summary>
TTMMessageList = class
  [ALIAS('page')]
  Page : Integer;
  [ALIAS('limit')]
  Limit : Integer;
  [ALIAS('pageCount')]
  PageCount : Integer;
  [ALIAS('resources')]
  Resources : TObjectList<TTMMessage>;
end;

/// <summary>
///   Chat message model
/// </summary>
TTMChatMessage = class
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('direction')]
  Direction : String;
  [ALIAS('sender')]
  Sender : String;
  [ALIAS('messageTime')]
  MessageTime : TDateTime;
  [ALIAS('text')]
  Text : String;
  [ALIAS('receiver')]
  Receiver : String;
  [ALIAS('status')]
  Status : String;
  [ALIAS('firstName')]
  FirstName : String;
  [ALIAS('lastName')]
  LastName : String;
end;

/// <summary>
///   Chat message model list
/// </summary>
TTMChatMessageList = class
  [ALIAS('page')]
  Page : Integer;
  [ALIAS('limit')]
  Limit : Integer;
  [ALIAS('pageCount')]
  PageCount : Integer;
  [ALIAS('resources')]
  Resources : TObjectList<TTMChatMessage>;
end;

/// <summary>
///   List model
/// </summary>
TTMList = class
  [ALIAS('name')]
  Name : String;
  [ALIAS('description')]
  Description : String;
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('membersCount')]
  MembersCount : Integer;
  [ALIAS('shared')]
  Shared : Boolean;
end;

/// <summary>
///   List model list
/// </summary>
TTMListList = class
  [ALIAS('page')]
  Page : Integer;
  [ALIAS('limit')]
  Limit : Integer;
  [ALIAS('pageCount')]
  PageCount : Integer;
  [ALIAS('resources')]
  Resources : TObjectList<TTMList>;
end;

/// <summary>
///   Template model
/// </summary>
TTMTemplate = class
  [ALIAS('name')]
  Name : String;
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('content')]
  Content : String;
  [ALIAS('lastModified')]
  LastModified : TDateTime;
end;

/// <summary>
///   Template model list
/// </summary>
TTMTemplateList = class
  [ALIAS('page')]
  Page : Integer;
  [ALIAS('limit')]
  Limit : Integer;
  [ALIAS('pageCount')]
  PageCount : Integer;
  [ALIAS('resources')]
  Resources : TObjectList<TTMTemplate>;
end;

/// <summary>
///   Custom filed model
/// </summary>
TTMCustomField = class
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('name')]
  Name : String;
  [ALIAS('createdAt')]
  CreatedAt : TDateTime;
end;

/// <summary>
///   Custom filed model list
/// </summary>
TTMCustomFieldList = class
  [ALIAS('page')]
  Page : Integer;
  [ALIAS('limit')]
  Limit : Integer;
  [ALIAS('pageCount')]
  PageCount : Integer;
  [ALIAS('resources')]
  Resources : TObjectList<TTMCustomField>;
end;

/// <summary>
///   Contact model
/// </summary>
TTMContact = class
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('firstName')]
  FirstName : String;
  [ALIAS('lastName')]
  LastName : String;
  [ALIAS('companyName')]
  CompanyName : String;
  [ALIAS('phone')]
  Phone : String;
  [ALIAS('email')]
  Email : String;
  [ALIAS('country')]
  Country : TTMCountry;
  [ALIAS('customFields')]
  CustomFields : TObjectList<TTMCustomField>;
end;

/// <summary>
///   Contact model list
/// </summary>
TTMContactList = class
  [ALIAS('page')]
  Page : Integer;
  [ALIAS('limit')]
  Limit : Integer;
  [ALIAS('pageCount')]
  PageCount : Integer;
  [ALIAS('resources')]
  Resources : TObjectList<TTMContact>;
end;

/// <summary>
///   Chat model
/// </summary>
TTMChat = class
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('phone')]
  Phone : Integer;
  [ALIAS('contact')]
  Contact : TTMContact;
  [ALIAS('unread')]
  Unread : Integer;
  [ALIAS('updatedAt')]
  UpdatedAt : TDateTime;
end;

/// <summary>
///   Chat model list
/// </summary>
TTMChatList = class
  [ALIAS('page')]
  Page : Integer;
  [ALIAS('limit')]
  Limit : Integer;
  [ALIAS('pageCount')]
  PageCount : Integer;
  [ALIAS('resources')]
  Resources : TObjectList<TTMChat>;
end;

/// <summary>
///   Unsubscribed contact model
/// </summary>
TTMUnsubscribedContact = class
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('phone')]
  Phone : String;
  [ALIAS('unsubscribeTime')]
  UnsubscribeTime : TDateTime;
  [ALIAS('firstName')]
  FirstName : String;
  [ALIAS('lastName')]
  LastName : String;
end;

/// <summary>
///   Unsubscribed contact model list
/// </summary>
TTMUnsubscribedContactList = class
  [ALIAS('page')]
  Page : Integer;
  [ALIAS('limit')]
  Limit : Integer;
  [ALIAS('pageCount')]
  PageCount : Integer;
  [ALIAS('resources')]
  Resources : TObjectList<TTMUnsubscribedContact>;
end;

/// <summary>
///   Message result
/// </summary>
TTMMessageResult = class
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('href')]
  Href : String;
  [ALIAS('type')]
  MessageType : String;
  [ALIAS('sessionId')]
  SessionId : Integer;
  [ALIAS('bulkId')]
  BulkId : Integer;
  [ALIAS('messageId')]
  MessageId : Integer;
  [ALIAS('scheduleId')]
  ScheduleId : Integer;
end;

/// <summary>
///   Message price result
/// </summary>
TTMMessagePriceResult = class
  [ALIAS('total')]
  Total : Real;
  [ALIAS('parts')]
  Parts : Integer;
end;

/// <summary>
///   Link result
/// </summary>
TTMLinkResult = class
  [ALIAS('id')]
  Id : Integer;
  [ALIAS('href')]
  Href : String;
end;

/// <summary>
///   REST API Exception
/// </summary>
TMException = class(Exception)
  private
    FErrorCode : Integer;
    FErrors : TDictionary<String, String>;
  public
    constructor CreateFromJSON(const aJSON : String);
    destructor Destroy;
    property ErrorCode : Integer read FErrorCode write FErrorCode;
    property Errors : TDictionary<String, String> read FErrors write FErrors;
end;

/// <summary>
///   Http response
/// </summary>
THttpResponse = record
  Code : Integer;
  Body : String;
end;

/// <summary>
///   TidHTTP override
/// </summary>
TIdHTTP = class(idHTTP.TIdHTTP)
  public
    procedure Delete(AURL: string; ASource, AResponseContent: TStream); overload;
    function Delete(AURL: string; ASource: TStream
      {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
      ): string; overload;
end;

/// <summary>
///   Textmagic client
/// </summary>
TTMClient = class(TObject)
  private
    FUsername : String;
    FToken : String;
    FBaseUrl : String;
    FUserAgent : String;
    FHeaders: TStringList;
    FSslHandler : TIdSSLIOHandlerSocketOpenSSL;
    LastExecuted : TDateTime;

    function GetHttpClientInstance() : TIdHTTP;
    procedure CheckExecutionTime();
    function UrlEncode(aStr : String) : String;
    function CreateStringParams(aParams : TStringList): String;
    function CreateStringStreamParams(aParams : TStringList): TStringStream;
    function CreateData(aPath : String; aParams: TStringList): THttpResponse;
    function DeleteData(aPath : String; aParams: TStringList) : THttpResponse;
    function RetrieveData(aPath : String; aParams : TStringList) : THttpResponse;
    function UpdateData(aPath : String; aParams: TStringList): THttpResponse;
  public
    constructor Create(aUsername : String; aToken : String; aUserAgent : String); overload;
    constructor Create(aUsername : String; aToken : String); overload;
    destructor Destroy;

    function GetContact(aId : Variant) : TTMContact;
    function GetContacts(aPage, aLimit, aShared : Variant) : TTMContactList; overload;
    function GetContacts(aPage, aLimit : Variant) : TTMContactList; overload;
    function GetContacts(aPage : Variant) : TTMContactList; overload;
    function SearchContacts(aPage, aLimit, aShared, aIds, aListIds, aQuery : Variant) : TTMContactList;
    function CreateContact(aPhone, aListIds, aFirstName, aLastName, aCompanyName, aEmail : Variant) : TTMLinkResult; overload;
    function CreateContact(aPhone, aListIds, aFirstName, aLastName : Variant) : TTMLinkResult; overload;
    function UpdateContact(aContact : TTMContact; aListIds : Variant) : TTMLinkResult;
    function DeleteContact(aId : Variant) : Boolean; overload;
    function DeleteContact(aContact : TTMContact) : Boolean; overload;
    function GetUnsubscribedContacts(aPage, aLimit : Variant) : TTMUnsubscribedContactList; overload;
    function GetUnsubscribedContacts(aPage : Variant) : TTMUnsubscribedContactList; overload;
    function GetUnsubscribedContact(aId : Variant) : TTMUnsubscribedContact;
    function UnsubscribeContact(aPhone : Variant) : TTMLinkResult; overload;
    function UnsubscribeContact(aContact : TTMContact) : TTMLinkResult; overload;
    function GetCustomField(aId : Variant) : TTMCustomField;
    function GetCustomFields(aPage, aLimit : Variant) : TTMCustomFieldList; overload;
    function GetCustomFields(aPage : Variant) : TTMCustomFieldList; overload;
    function CreateCustomField(aName : Variant) : TTMLinkResult;
    function UpdateCustomField(aCustomField : TTMCustomField) : TTMLinkResult;
    function SetCustomFieldValue(aId, aContactId, aValue : Variant) : TTMContact;
    function DeleteCustomField(aId : Variant) : Boolean; overload;
    function DeleteCustomField(aCustomField : TTMCustomField) : Boolean; overload;
    function GetTemplate(aId : Variant) : TTMTemplate;
    function GetTemplates(aPage, aLimit : Variant) : TTMTemplateList; overload;
    function GetTemplates(aPage : Variant) : TTMTemplateList; overload;
    function SearchTemplates(aPage, aLimit, aIds, aName, aContent : Variant) : TTMTemplateList;
    function CreateTemplate(aName, aContent : Variant) : TTMLinkResult;
    function UpdateTemplate(aTemplate : TTMTemplate) : TTMLinkResult;
    function DeleteTemplate(aId : Variant) : Boolean; overload;
    function DeleteTemplate(aTemplate : TTMTemplate) : Boolean; overload;
    function GetList(aId : Variant) : TTMList;
    function GetLists(aPage, aLimit : Variant) : TTMListList; overload;
    function GetLists(aPage : Variant) : TTMListList; overload;
    function SearchLists(aPage, aLimit, aIds, aQuery : Variant) : TTMListList;
    function CreateList(aName, aDescription : Variant; aShared : Boolean) : TTMLinkResult; overload;
    function CreateList(aName : Variant) : TTMLinkResult; overload;
    function UpdateList(aList : TTMList) : TTMLinkResult;
    function DeleteList(aId : Variant) : Boolean; overload;
    function DeleteList(aList : TTMList) : Boolean; overload;
    function GetListContacts(aId, aPage, aLimit : Variant) : TTMContactList; overload;
    function GetListContacts(aId, aPage : Variant) : TTMContactList; overload;
    function GetListContacts(aList : TTMList; aPage, aLimit : Variant) : TTMContactList; overload;
    function GetListContacts(aList : TTMList; aPage : Variant) : TTMContactList; overload;
    function AddContactsToList(aList : TTMList; aContacts : TObjectList<TTMContact>) : TTMLinkResult; overload;
    function AddContactsToList(aId, aContacts : Variant) : TTMLinkResult; overload;
    function DeleteContactsFromList(aList : TTMList; aContacts : TObjectList<TTMContact>) : Boolean; overload;
    function DeleteContactsFromList(aId, aContacts : Variant) : Boolean; overload;
    function GetMessage(aId : Variant) : TTMMessage;
    function GetMessages(aPage, aLimit : Variant) : TTMMessageList; overload;
    function GetMessages(aPage : Variant) : TTMMessageList; overload;
    function SearchMessages(aPage, aLimit, aIds, aSessionId, aQuery : Variant) : TTMMessageList;
    function CreateMessage(aText, aTemplateId, aSendingTime, aContactIds, aListIds, aPhones, aCutExtra, aPartsCount, aReferenceId, aFrom, aRrule : Variant) : TTMMessageResult;
    function GetPrice(aText, aTemplateId, aSendingTime, aContactIds, aListIds, aPhones, aCutExtra, aPartsCount, aReferenceId, aFrom, aRrule : Variant) : TTMMessagePriceResult;
    function DeleteMessage(aId : Variant) : Boolean; overload;
    function DeleteMessage(aMessage : TTMMessage) : Boolean; overload;
    function GetChats(aPage, aLimit : Variant) : TTMChatList; overload;
    function GetChats(aPage : Variant) : TTMChatList; overload;
    function GetChatMessages(aPhone, aPage, aLimit : Variant) : TTMChatMessageList; overload;
    function GetChatMessages(aPhone, aPage : Variant) : TTMChatMessageList; overload;
    function GetBulkSession(aId : Variant) : TTMBulkSession;
    function GetBulkSessions(aPage, aLimit : Variant) : TTMBulkSessionList; overload;
    function GetBulkSessions(aPage : Variant) : TTMBulkSessionList; overload;
    function GetSession(aId : Variant) : TTMSession;
    function GetSessions(aPage, aLimit : Variant) : TTMSessionList; overload;
    function GetSessions(aPage : Variant) : TTMSessionList; overload;
    function GetSessionMessages(aId, aPage, aLimit : Variant) : TTMMessageList; overload;
    function GetSessionMessages(aId, aPage : Variant) : TTMMessageList; overload;
    function DeleteSession(aId : Variant) : Boolean; overload;
    function DeleteSession(aSession : TTMSession) : Boolean; overload;
    function GetSchedule(aId : Variant) : TTMSchedule;
    function GetSchedules(aPage, aLimit : Variant) : TTMScheduleList; overload;
    function GetSchedules(aPage : Variant) : TTMScheduleList; overload;
    function DeleteSchedule(aId : Variant) : Boolean; overload;
    function DeleteSchedule(aSchedule : TTMSchedule) : Boolean; overload;
    function GetReply(aId : Variant) : TTMReply;
    function GetReplies(aPage, aLimit : Variant) : TTMReplyList; overload;
    function GetReplies(aPage : Variant) : TTMReplyList; overload;
    function SearchReplies(aPage, aLimit, aIds, aQuery : Variant) : TTMReplyList;
    function DeleteReply(aId : Variant) : Boolean; overload;
    function DeleteReply(aReply : TTMReply) : Boolean; overload;
    function GetInvoices(aPage, aLimit : Variant) : TTMInvoiceList; overload;
    function GetInvoices(aPage : Variant) : TTMInvoiceList; overload;
    function GetSources(aCountry : Variant) : TTMSources; overload;
    function GetSources() : TTMSources; overload;
    function GetNumber(aId : Variant) : TTMNumber;
    function GetNumbers(aPage, aLimit : Variant) : TTMNumberList; overload;
    function GetNumbers(aPage : Variant) : TTMNumberList; overload;
    function GetAvailableNumbers(aCountry, aPrefix : Variant) : TTMAvailableNumberList; overload;
    function GetAvailableNumbers(aCountry : Variant) : TTMAvailableNumberList; overload;
    function BuyNumber(aPhone, aCountry, aUserId : Variant) : TTMLinkResult;
    function DeleteNumber(aId : Variant) : Boolean; overload;
    function DeleteNumber(aNumber : TTMNumber) : Boolean; overload;
    function GetSenderId(aId : Variant) : TTMSenderId;
    function GetSenderIds(aPage, aLimit : Variant) : TTMSenderIdList; overload;
    function GetSenderIds(aPage : Variant) : TTMSenderIdList; overload;
    function CreateSenderId(aSenderId, aExplanation : Variant) : TTMLinkResult;
    function DeleteSenderId(aId : Variant) : Boolean; overload;
    function DeleteSenderId(aSenderId : TTMSenderId) : Boolean; overload;
    function GetSubaccount(aId : Variant) : TTMUser;
    function GetSubaccounts(aPage, aLimit : Variant) : TTMUserList; overload;
    function GetSubaccounts(aPage : Variant) : TTMUserList; overload;
    function InviteSubaccount(aEmail, aRole : Variant) : Boolean;
    function CloseSubaccount(aId : Variant) : Boolean; overload;
    function CloseSubaccount(aSubaccount : TTMUser) : Boolean; overload;
    function GetStatements(aPage, aLimit : Variant) : TTMStatementList; overload;
    function GetStatements(aPage : Variant) : TTMStatementList; overload;
    function GetUser() : TTMUser;
    function UpdateUser(aFirstName, aLastName, aCompany : Variant) : TTMLinkResult; overload;
    function UpdateUser(aUser : TTMUser) : TTMLinkResult; overload;
end;

const
  Id_HTTPMethodDelete = 'DELETE';

  API_URI = 'https://rest.textmagic.com/api/v2/';
  DEFAULT_USER_AGENT = 'textmagic-rest-object-pascal/2.00';

implementation

/// <summary>
///   Available number list constructor
/// </summary>
constructor TTMAvailableNumberList.Create;
begin
  Self.Numbers := TStringList.Create;
end;

/// <summary>
///   Available number list destructor
/// </summary>
destructor TTMAvailableNumberList.Destroy;
begin
  Self.Numbers.Free;
end;

/// <summary>
///   User sources list constructor
/// </summary>
constructor TTMSources.Create;
begin
  Self.Dedicated := TStringList.Create;
  Self.Shared := TStringList.Create;
  Self.SenderIds := TStringList.Create;
end;

/// <summary>
///   User sources list destructor
/// </summary>
destructor TTMSources.Destroy;
begin
  Self.Dedicated.Free;
  Self.Shared.Free;
  Self.SenderIds.Free;
end;

/// <summary>
///   REST API Exception constructor
/// </summary>
/// <param name="aJSON">
///   Error JSON response
/// </param>
constructor TMException.CreateFromJSON(const aJSON : String);
var
  J : Integer;
  FormChildren,
  ExceptionErrors,
  JSONException : ISuperObject;
  FormField,
  FormFieldError : IMember;
  Errors : String;
begin
  JSONException := TSuperObject.Create(aJSON);
  inherited Create(JSONException.S['message']);
  Self.FErrorCode := JSONException.I['code'];
  Self.Errors := TDictionary<String, String>.Create;
  if JSONException.GetType('errors') = varObject then
  begin
    ExceptionErrors := JSONException.O['errors'];
    if ExceptionErrors.Contains('common') then
    begin
      Errors := '';
      for FormFieldError in ExceptionErrors.A['common'] do
      begin
        Errors := Errors + FormFieldError.AsString + #13#10;
      end;
      if Errors <> '' then
        Self.Errors.Add('common', Errors);
    end;
    if ExceptionErrors.Contains('fields') then
    begin
      for FormField in ExceptionErrors.O['fields'] do
      begin
        Errors := '';
        for FormFieldError in FormField.AsArray do
        begin
          Errors := Errors + FormFieldError.AsString + #13#10;
        end;
        if Errors <> '' then
          Self.Errors.Add(FormField.Name, Errors);
      end;
    end;
  end;
end;

/// <summary>
///   REST API Exception destructor
/// </summary>
destructor TMException.Destroy;
begin
  Self.Errors.Free;
  inherited Destroy;
end;

/// <summary>
///   TidHTTP DELETE method override
/// </summary>
procedure TIdHTTP.Delete(AURL: string; ASource, AResponseContent: TStream);
begin
  DoRequest(Id_HTTPMethodDelete, AURL, ASource, AResponseContent, []);
end;

/// <summary>
///   TidHTTP DELETE method override
/// </summary>
function TIdHTTP.Delete(AURL: string; ASource: TStream
  {$IFDEF STRING_IS_ANSI}; ADestEncoding: IIdTextEncoding = nil{$ENDIF}
  ): string;
var
  LStream: TMemoryStream;
begin
  LStream := TMemoryStream.Create;
  try
    DoRequest(Id_HTTPMethodDelete, AURL, ASource, LStream, []);
    LStream.Position := 0;
    Result := ReadStringAsCharset(LStream, ResponseCharset{$IFDEF STRING_IS_ANSI}, ADestEncoding{$ENDIF});

  finally
    FreeAndNil(LStream);
  end;
end;

/// <summary>
///   Textmagic client constructor
/// </summary>
/// <param name="aUsername">
///   Account username
/// </param>
/// <param name="aToken">
///   REST API access token (key)
/// </param>
/// <param name="aUserAgent">
///   Client user agent
/// </param>
constructor TTMClient.Create(aUsername : String; aToken : String; aUserAgent : String);
begin
  inherited Create();
  Self.FUsername := aUsername;
  Self.FToken := aToken;
  Self.FBaseUrl := API_URI;
  Self.FUserAgent := aUserAgent;
  Self.FHeaders := TStringList.Create;
  Self.FSslHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  Self.LastExecuted := Now;
end;

/// <summary>
///   Textmagic client constructor
/// </summary>
/// <param name="aUsername">
///   Account username
/// </param>
/// <param name="aToken">
///   REST API access token (key)
/// </param>
constructor TTMClient.Create(aUsername : String; aToken : String);
begin
  Create(aUsername, aToken, DEFAULT_USER_AGENT);
end;

/// <summary>
///   Textmagic client destructor
/// </summary>
destructor TTMClient.Destroy;
begin
  Self.FHeaders.Free;
  Self.FSslHandler.Free;
  inherited Destroy;
end;

/// <summary>
///   Url encode
/// </summary>
/// <param name="aStr">
///   Value
/// </param>
/// <returns>
///   String
/// </returns>
function TTMClient.UrlEncode(aStr : String) : String;
var
  I : Integer;
const
  UnsafeChars = ['*', '#', '%', '<', '>', ' ','[',']','@','+'];
begin
  Result := '';
  for I := 1 to Length(aStr) do
  begin
    if (aStr[I] in UnsafeChars) or (not (ord(aStr[I]) in [33..128])) then
    begin
      Result := Result + '%' + IntToHex(Ord(aStr[I]), 2);
    end
    else
    begin
      Result := Result + aStr[I];
    end;
  end;
end;

/// <summary>
///   Create params string for query from params list
/// </summary>
/// <param name="aParams">
///   Params list
/// </param>
/// <returns>
///   String
/// </returns>
function TTMClient.CreateStringParams(aParams : TStringList): String;
var
  I : Integer;
  Key,
  Value,
  Str : String;
begin
  Result := '';
  if Assigned(aParams) then
  begin
    for I := 0 to aParams.Count - 1 do
    begin
      Key := aParams.Names[I];
      Value := aParams.ValueFromIndex[I];
      Str := urlEncode(Key) + '=' + urlEncode(Value);
      if not (I = aParams.Count - 1) then Str := Str + '&';
      Result := Result + Str;
    end;
  end
  else
    Result := '';
end;

/// <summary>
///   Create params stream for query from params list
/// </summary>
/// <param name="aParams">
///   Params list
/// </param>
/// <returns>
///   TStringStream
/// </returns>
function TTMClient.CreateStringStreamParams(aParams : TStringList): TStringStream;
var
  Str : String;
begin
  Result := TStringStream.Create('');
  Str := CreateStringParams(aParams);
  if Length(Str) > 0 then
    Result.WriteString(Str);
end;

/// <summary>
///   Initialize TextMagic REST client instance
/// </summary>
/// <returns>
///   TIdHTTP
/// </returns>
function TTMClient.GetHttpClientInstance() : TIdHTTP;
begin
  Result := TIdHTTP.Create(nil);
  Result.ConnectTimeout := 5000;
  Result.ReadTimeout := 5000;
  Result.IOHandler := Self.FSslHandler;
  Result.Request.CustomHeaders.Clear;
  Result.Request.CustomHeaders.AddStrings(Self.FHeaders);
  Result.Request.CustomHeaders.Add('X-TM-Username: ' + Self.FUsername);
  Result.Request.CustomHeaders.Add('X-TM-Key: ' + Self.FToken);
  Result.Request.Accept := 'application/json, application/xml';
  Result.Request.ContentType := '';
  Result.Request.AcceptCharSet := 'UTF-8';
  Result.Request.AcceptLanguage := 'en-US';
end;

/// <summary>
///   Check last request execution time and make delay, if needed
/// </summary>
procedure TTMClient.CheckExecutionTime();
begin
  if MilliSecondsBetween(Now, Self.LastExecuted) < 500 then
  begin
    Sleep(500);
  end;
  Self.LastExecuted := Now;
end;

/// <summary>
///   Create POST request to REST API
/// </summary>
/// <param name="aPath">
///   Path to resource
/// </param>
/// <param name="aParams">
///   Params list
/// </param>
/// <returns>
///   THttpResponse
/// </returns>
function TTMClient.CreateData(aPath : String; aParams: TStringList): THttpResponse;
var
  HttpClient : TIdHTTP;
  Params : TStringStream;
  Response : String;
begin
  HttpClient := getHttpClientInstance();
  try
    Params := createStringStreamParams(aParams);
    HttpClient.Request.ContentType := 'application/x-www-form-urlencoded';
    CheckExecutionTime();
    try
      Response := HttpClient.Post(aPath, Params);
    finally
      Params.Free;
    end;
    Result.Code := httpClient.ResponseCode;
    Result.Body := Response;
  except
    on E: EIdHTTPProtocolException do
    begin
      raise TMException.CreateFromJSON(E.ErrorMessage);
    end;
  end;
  HttpClient.Free;
end;

/// <summary>
///   Create DELETE request to REST API
/// </summary>
/// <param name="aPath">
///   Path to resource
/// </param>
/// <param name="aParams">
///   Params list
/// </param>
/// <returns>
///   THttpResponse
/// </returns>
function TTMClient.DeleteData(aPath : String; aParams: TStringList) : THttpResponse;
var
  HttpClient : TIdHTTP;
  Params : TStringStream;
  Response : String;
begin
  HttpClient := getHttpClientInstance();
  try
    Params := createStringStreamParams(aParams);
    HttpClient.Request.ContentType := 'application/x-www-form-urlencoded';
    CheckExecutionTime();
    try
      Response := HttpClient.Delete(aPath, Params);
    finally
      Params.Free;
    end;
    Result.Code := httpClient.ResponseCode;
    Result.Body := Response;
  except
    on E: EIdHTTPProtocolException do
    begin
      raise TMException.CreateFromJSON(E.ErrorMessage);
    end;
  end;
  HttpClient.Free;
end;

/// <summary>
///   Create GET request to REST API
/// </summary>
/// <param name="aPath">
///   Path to resource
/// </param>
/// <param name="aParams">
///   Params list
/// </param>
/// <returns>
///   THttpResponse
/// </returns>
function TTMClient.RetrieveData(aPath : String; aParams : TStringList) : THttpResponse;
var
  HttpClient : TIdHTTP;
  Params,
  Response : String;
begin
  HttpClient := getHttpClientInstance();
  try
    Params := CreateStringParams(aParams);
    CheckExecutionTime();
    Response := HttpClient.Get(aPath + '?' + Params);
    Result.Code := HttpClient.ResponseCode;
    Result.Body := Response;
  except
    on E: EIdHTTPProtocolException do
    begin
      raise TMException.CreateFromJSON(E.ErrorMessage);
    end;
  end;
  httpClient.Free;
end;

/// <summary>
///   Create PUT request to REST API
/// </summary>
/// <param name="aPath">
///   Path to resource
/// </param>
/// <param name="aParams">
///   Params list
/// </param>
/// <returns>
///   THttpResponse
/// </returns>
function TTMClient.UpdateData(aPath : String; aParams : TStringList) : THttpResponse;
var
  HttpClient : TIdHTTP;
  Params : TStringStream;
  Response : String;
begin
  HttpClient := getHttpClientInstance();
  try
    Params := createStringStreamParams(aParams);
    HttpClient.Request.ContentType := 'application/x-www-form-urlencoded';
    CheckExecutionTime();
    try
      Response := HttpClient.Put(aPath, Params);
    finally
      Params.Free;
    end;

    Result.Code := httpClient.ResponseCode;
    Result.Body := Response;
  except
    on E: EIdHTTPProtocolException do
    begin
      raise TMException.CreateFromJSON(E.ErrorMessage);
    end;
  end;
  HttpClient.Free;
end;

/// <summary>
///   Get a single contact
/// </summary>
/// <param name="aId">
///   Contact ID
/// </param>
/// <returns>
///   TTMContact
/// </returns>
function TTMClient.GetContact(aId : Variant) : TTMContact;
var
  Contact : TTMContact;
begin
  try
    Contact := TTMContact.FromJSON(RetrieveData(Self.FBaseUrl + 'contacts/' + VarToStr(aId), nil).Body);
  finally
    Result := Contact;
  end;
end;

/// <summary>
///   Get all user contacts
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMContactList
/// </returns>
function TTMClient.GetContacts(aPage, aLimit, aShared : Variant) : TTMContactList;
var
  Params : TStringList;
  ContactList : TTMContactList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  if not VarIsNull(aShared) then
    Params.Add('shared=' + VarToStr(aShared));
  try
    ContactList := TTMContactList.FromJSON(RetrieveData(Self.FBaseUrl + 'contacts', Params).Body);
  finally
    Result := ContactList;
  end;
  Params.Free;
end;

/// <summary>
///   Get all user contacts
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMContactList
/// </returns>
function TTMClient.GetContacts(aPage, aLimit : Variant) : TTMContactList;
begin
  Result := GetContacts(aPage, aLimit, null);
end;

/// <summary>
///   Get all user contacts
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMContactList
/// </returns>
function TTMClient.GetContacts(aPage : Variant) : TTMContactList;
begin
  Result := GetContacts(aPage, null, null);
end;

/// <summary>
///   Find user contacts by given parameters
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <param name="aShared">
///   Should shared contacts to be included
/// </param>
/// <param name="aIds">
///   Find contact by ID(s)
/// </param>
/// <param name="aListIds">
///   Find contact by List ID
/// </param>
/// <param name="aQuery">
///   Find contact by specified search query
/// </param>
/// <returns>
///   TTMContactList
/// </returns>
function TTMClient.SearchContacts(aPage, aLimit, aShared, aIds, aListIds, aQuery : Variant) : TTMContactList;
var
  Params : TStringList;
  ContactList : TTMContactList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  if not VarIsNull(aShared) then
    Params.Add('shared=' + VarToStr(aShared));
  if not VarIsNull(aIds) then
    Params.Add('ids=' + VarToStr(aIds));
  if not VarIsNull(aListIds) then
    Params.Add('listId=' + VarToStr(aListIds));
  if not VarIsNull(aQuery) then
    Params.Add('query=' + VarToStr(aQuery));
  try
    ContactList := TTMContactList.FromJSON(RetrieveData(Self.FBaseUrl + 'contacts', Params).Body);
  finally
    Result := ContactList;
  end;
  Params.Free;
end;

/// <summary>
///   Create a new contact from the submitted data
/// </summary>
/// <param name="aPhone">
///   Contact phone number in E.164 format
/// </param>
/// <param name="aListIds">
///   List IDs this contact will be assigned to
/// </param>
/// <param name="aFirstName">
///   First name
/// </param>
/// <param name="aLastName">
///   Last name
/// </param>
/// <param name="aCompanyName">
///   Company name
/// </param>
/// <param name="aEmail">
///   Email
/// </param>
/// <returns>
///   TTMLinkResult
/// </returns>
function TTMClient.CreateContact(aPhone, aListIds, aFirstName, aLastName, aCompanyName, aEmail : Variant) : TTMLinkResult;
var
  Params : TStringList;
  LinkResult : TTMLinkResult;
begin
  Params := TStringList.Create;

  Params.Add('phone=' + VarToStr(aPhone));
  Params.Add('lists=' + VarToStr(aListIds));
  Params.Add('firstName=' + VarToStr(aFirstName));
  Params.Add('lastName=' + VarToStr(aLastName));
  Params.Add('companyName=' + VarToStr(aCompanyName));
  Params.Add('email=' + VarToStr(aEmail));
  try
    LinkResult := TTMLinkResult.FromJSON(CreateData(Self.FBaseUrl + 'contacts', Params).Body);
  finally
    Result := LinkResult;
  end;
  Params.Free;
end;

/// <summary>
///   Create a new contact from the submitted data
/// </summary>
/// <param name="aPhone">
///   Contact phone number in E.164 format
/// </param>
/// <param name="aListIds">
///   List IDs this contact will be assigned to
/// </param>
/// <param name="aFirstName">
///   First name
/// </param>
/// <param name="aLastName">
///   Last name
/// </param>
/// <returns>
///   TTMLinkResult
/// </returns>
function TTMClient.CreateContact(aPhone, aListIds, aFirstName, aLastName : Variant) : TTMLinkResult;
begin
  Result := CreateContact(aPhone, AlistIds, AFirstName, aLastName, null, null);
end;

/// <summary>
///   Update existing contact
/// </summary>
/// <param name="aContact">
///   Contact model
/// </param>
/// <param name="aListIds">
///   List IDs this contact will be assigned to
/// </param>
/// <returns>
///   TTMLinkResult
/// </returns>
function TTMClient.UpdateContact(aContact : TTMContact; aListIds : Variant) : TTMLinkResult;
var
  Params : TStringList;
  LinkResult : TTMLinkResult;
begin
  Params := TStringList.Create;

  Params.Add('phone=' + aContact.Phone);
  Params.Add('lists=' + VarToStr(aListIds));
  Params.Add('firstName=' + aContact.FirstName);
  Params.Add('lastName=' + aContact.LastName);
  Params.Add('companyName=' + aContact.CompanyName);
  Params.Add('email=' + aContact.Email);
  Params.Add('country=' + aContact.Country.id);
  try
    LinkResult := TTMLinkResult.FromJSON(UpdateData(Self.FBaseUrl + 'contacts/' + IntToStr(aContact.Id), Params).Body);
  finally
    Result := LinkResult;
  end;
  Params.Free;
end;

/// <summary>
///   Delete a single contact
/// </summary>
/// <param name="aId">
///   Contact ID
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteContact(aId : Variant) : Boolean;
var
  ResponseCode : Integer;
begin
  try
    ResponseCode := DeleteData(Self.FBaseUrl + 'contacts/' + VarToStr(aId), nil).Code;
  finally
    Result := (ResponseCode = 204);
  end;
end;

/// <summary>
///   Delete a single contact
/// </summary>
/// <param name="aContact">
///   Contact model
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteContact(aContact : TTMContact) : Boolean;
begin
  Result := DeleteContact(aContact.id);
end;

/// <summary>
///   Get all contact unsubscribed from your communication
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMUnsubscribedContactList
/// </returns>
function TTMClient.GetUnsubscribedContacts(aPage, aLimit : Variant) : TTMUnsubscribedContactList;
var
  Params : TStringList;
  UnsubscribedContactList : TTMUnsubscribedContactList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  try
    UnsubscribedContactList := TTMUnsubscribedContactList.FromJSON(RetrieveData(Self.FBaseUrl + 'unsubscribers', Params).Body);
  finally
    Result := UnsubscribedContactList;
  end;
  Params.Free;
end;

/// <summary>
///   Get all contact unsubscribed from your communication
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMUnsubscribedContactList
/// </returns>
function TTMClient.GetUnsubscribedContacts(aPage : Variant) : TTMUnsubscribedContactList;
begin
  Result := GetUnsubscribedContacts(aPage, null);
end;

/// <summary>
///   Get a single unsubscribed contact
/// </summary>
/// <param name="aId">
///   Unsubscribed contact ID
/// </param>
/// <returns>
///   TTMUnsubscribedContact
/// </returns>
function TTMClient.GetUnsubscribedContact(aId : Variant) : TTMUnsubscribedContact;
var
  UnsubscribedContact : TTMUnsubscribedContact;
begin
  try
    UnsubscribedContact := TTMUnsubscribedContact.FromJSON(RetrieveData(Self.FBaseUrl + 'unsubscribers/' + VarToStr(aId), nil).Body);
  finally
    Result := UnsubscribedContact;
  end;
end;

/// <summary>
///   Unsubscribe contact from your communication
/// </summary>
/// <param name="aPhone">
///   Contact phone number (may not be in your contact list)
/// </param>
/// <returns>
///   TTMLinkResult
/// </returns>
function TTMClient.UnsubscribeContact(aPhone : Variant) : TTMLinkResult;
var
  Params : TStringList;
  LinkResult : TTMLinkResult;
begin
  Params := TStringList.Create;

  Params.Add('phone=' + VarToStr(aPhone));
  try
    LinkResult := TTMLinkResult.FromJSON(CreateData(Self.FBaseUrl + 'unsubscribers', Params).Body);
  finally
    Result := LinkResult;
  end;
  Params.Free;
end;

/// <summary>
///   Unsubscribe contact from your communication
/// </summary>
/// <param name="aContact">
///   Contact model
/// </param>
/// <returns>
///   TTMLinkResult
/// </returns>
function TTMClient.UnsubscribeContact(aContact : TTMContact) : TTMLinkResult;
begin

  Result := UnsubscribeContact(aContact.Phone);
end;

/// <summary>
///   Get a single custom field
/// </summary>
/// <param name="aId">
///   Custom field ID
/// </param>
/// <returns>
///   TTMCustomField
/// </returns>
function TTMClient.GetCustomField(aId : Variant) : TTMCustomField;
var
  CustomField : TTMCustomField;
begin
  try
    CustomField := TTMCustomField.FromJSON(RetrieveData(Self.FBaseUrl + 'customfields/' + VarToStr(aId), nil).Body);
  finally
    Result := CustomField;
  end;
end;

/// <summary>
///   Get all available contact custom fields
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMCustomFieldList
/// </returns>
function TTMClient.GetCustomFields(aPage, aLimit : Variant) : TTMCustomFieldList;
var
  Params : TStringList;
  CustomFieldList : TTMCustomFieldList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  try
    CustomFieldList := TTMCustomFieldList.FromJSON(RetrieveData(Self.FBaseUrl + 'customfields', Params).Body);
  finally
    Result := CustomFieldList;
  end;
  Params.Free;
end;

/// <summary>
///   Get all available contact custom fields
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMCustomFieldList
/// </returns>
function TTMClient.GetCustomFields(aPage : Variant) : TTMCustomFieldList;
begin
  Result := GetCustomFields(aPage, null);
end;

/// <summary>
///   Create a new custom field
/// </summary>
/// <param name="aName">
///   Custom field name
/// </param>
/// <returns>
///   TTMLinkResult
/// </returns>
function TTMClient.CreateCustomField(aName : Variant) : TTMLinkResult;
var
  Params : TStringList;
  LinkResult : TTMLinkResult;
begin
  Params := TStringList.Create;

  Params.Add('name=' + VarToStr(aName));
  try
    LinkResult := TTMLinkResult.FromJSON(CreateData(Self.FBaseUrl + 'customfields', Params).Body);
  finally
    Result := LinkResult;
  end;
  Params.Free;
end;

/// <summary>
///   Update existing custom field
/// </summary>
/// <param name="aCustomField">
///   Custom field model
/// </param>
/// <returns>
///   TTMLinkResult
/// </returns>
function TTMClient.UpdateCustomField(aCustomField : TTMCustomField) : TTMLinkResult;
var
  Params : TStringList;
  LinkResult : TTMLinkResult;
begin
  Params := TStringList.Create;

  Params.Add('name=' + aCustomField.Name);
  try
    LinkResult := TTMLinkResult.FromJSON(UpdateData(Self.FBaseUrl + 'customfields/' + IntToStr(aCustomField.Id), Params).Body);
  finally
    Result := LinkResult;
  end;
  Params.Free;
end;

/// <summary>
///   Set contact's custom field value
/// </summary>
/// <param name="aId">
///   Custom field ID
/// </param>
/// <param name="aContactId">
///   Contact ID
/// </param>
/// <param name="aValue">
///   Custom field value
/// </param>
/// <returns>
///   TTMContact
/// </returns>
function TTMClient.SetCustomFieldValue(aId, aContactId, aValue : Variant) : TTMContact;
var
  Params : TStringList;
  Contact : TTMContact;
begin
  Params := TStringList.Create;

  Params.Add('contactId=' + VarToStr(aContactId));
  Params.Add('value=' + VarToStr(aValue));
  try
    Contact := TTMContact.FromJSON(UpdateData(Self.FBaseUrl + 'customfields/' + VarToStr(aId) + '/update', Params).Body);
  finally
    Result := Contact;
  end;
  Params.Free;
end;

/// <summary>
///   Delete a single custom field
/// </summary>
/// <param name="aId">
///   Custom field ID
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteCustomField(aId : Variant) : Boolean;
var
  ResponseCode : Integer;
begin
  try
    ResponseCode := DeleteData(Self.FBaseUrl + 'customfields/' + VarToStr(aId), nil).Code;
  finally
    Result := (ResponseCode = 204);
  end;
end;

/// <summary>
///   Delete a single custom field
/// </summary>
/// <param name="aCustomField">
///   Custom field model
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteCustomField(aCustomField : TTMCustomField) : Boolean;
begin
  Result := DeleteCustomField(aCustomField.id);
end;

/// <summary>
///   Get a single template
/// </summary>
/// <param name="aId">
///   Template ID
/// </param>
/// <returns>
///   TTMTemplate
/// </returns>
function TTMClient.GetTemplate(aId : Variant) : TTMTemplate;
var
  Template : TTMTemplate;
begin
  try
    Template := TTMTemplate.FromJSON(RetrieveData(Self.FBaseUrl + 'templates/' + VarToStr(aId), nil).Body);
  finally
    Result := Template;
  end;
end;

/// <summary>
///   Get all user templates
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMTemplateList
/// </returns>
function TTMClient.GetTemplates(aPage, aLimit : Variant) : TTMTemplateList;
var
  Params : TStringList;
  TemplateList : TTMTemplateList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  try
    TemplateList := TTMTemplateList.FromJSON(RetrieveData(Self.FBaseUrl + 'templates', Params).Body);
  finally
    Result := TemplateList;
  end;
  Params.Free;
end;

/// <summary>
///   Get all user templates
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMTemplateList
/// </returns>
function TTMClient.GetTemplates(aPage : Variant) : TTMTemplateList;
begin
  Result := GetTemplates(aPage, null);
end;

/// <summary>
///   Find user templates by given parameters
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <param name="aIds">
///   Find template by ID
/// </param>
/// <param name="aName">
///   >Find template by name
/// </param>
/// <param name="aContent">
///   Find template by content
/// </param>
/// <returns>
///   TTMTemplateList
/// </returns>
function TTMClient.SearchTemplates(aPage, aLimit, aIds, aName, aContent : Variant) : TTMTemplateList;
var
  Params : TStringList;
  TemplateList : TTMTemplateList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  if not VarIsNull(aIds) then
    Params.Add('ids=' + VarToStr(aIds));
  if not VarIsNull(aName) then
    Params.Add('name=' + VarToStr(aName));
  if not VarIsNull(aContent) then
    Params.Add('content=' + VarToStr(aContent));
  try
    TemplateList := TTMTemplateList.FromJSON(RetrieveData(Self.FBaseUrl + 'templates', Params).Body);
  finally
    Result := TemplateList;
  end;
  Params.Free;
end;

/// <summary>
///   Create a new template from the submitted data
/// </summary>
/// <param name="aName">
///   Template name
/// </param>
/// <param name="aContent">
///   Template text. May contain tags inside braces
/// </param>
/// <returns>
///   TTMLinkResult
/// </returns>
function TTMClient.CreateTemplate(aName, aContent : Variant) : TTMLinkResult;
var
  Params : TStringList;
  LinkResult : TTMLinkResult;
begin
  Params := TStringList.Create;

  Params.Add('name=' + VarToStr(aName));
  Params.Add('content=' + VarToStr(aContent));
  try
    LinkResult := TTMLinkResult.FromJSON(CreateData(Self.FBaseUrl + 'templates', Params).Body);
  finally
    Result := LinkResult;
  end;
  Params.Free;
end;

/// <summary>
///   Update existing template
/// </summary>
/// <param name="aTemplate">
///   Template model
/// </param>
/// <returns>
///   TTMLinkResult
/// </returns>
function TTMClient.UpdateTemplate(aTemplate : TTMTemplate) : TTMLinkResult;
var
  Params : TStringList;
  LinkResult : TTMLinkResult;
begin
  Params := TStringList.Create;

  Params.Add('name=' + aTemplate.Name);
  Params.Add('content=' + aTemplate.Content);
  try
    LinkResult := TTMLinkResult.FromJSON(UpdateData(Self.FBaseUrl + 'templates/' + IntToStr(aTemplate.Id), Params).Body);
  finally
    Result := LinkResult;
  end;
  Params.Free;
end;

/// <summary>
///   Delete a single template
/// </summary>
/// <param name="aId">
///   Template ID
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteTemplate(aId : Variant) : Boolean;
var
  ResponseCode : Integer;
begin
  try
    ResponseCode := DeleteData(Self.FBaseUrl + 'templates/' + VarToStr(aId), nil).Code;
  finally
    Result := (ResponseCode = 204);
  end;
end;

/// <summary>
///   Delete a single template
/// </summary>
/// <param name="aTemplate">
///   Template model
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteTemplate(aTemplate : TTMTemplate) : Boolean;
begin
  Result := DeleteTemplate(aTemplate.Id);
end;

/// <summary>
///   Get a single list
/// </summary>
/// <param name="aId">
///   List ID
/// </param>
/// <returns>
///   TTMList
/// </returns>
function TTMClient.GetList(aId : Variant) : TTMList;
var
  List : TTMList;
begin
  try
    List := TTMList.FromJSON(RetrieveData(Self.FBaseUrl + 'lists/' + VarToStr(aId), nil).Body);
  finally
    Result := List;
  end;
end;

/// <summary>
///   Get all user lists
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMListList
/// </returns>
function TTMClient.GetLists(aPage, aLimit : Variant) : TTMListList;
var
  Params : TStringList;
  ListList : TTMListList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  try
    ListList := TTMListList.FromJSON(RetrieveData(Self.FBaseUrl + 'lists', Params).Body);
  finally
    Result := ListList;
  end;
  Params.Free;
end;

/// <summary>
///   Get all user lists
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMListList
/// </returns>
function TTMClient.GetLists(aPage : Variant) : TTMListList;
begin
  Result := GetLists(aPage, null);
end;

/// <summary>
///   Find contact lists by given parameters
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <param name="aIds">
///   Find lists by ID(s)
/// </param>
/// <param name="aQuery">
///   Find lists by specified search query
/// </param>
/// <returns>
///   TTMListList
/// </returns>
function TTMClient.SearchLists(aPage, aLimit, aIds, aQuery : Variant) : TTMListList;
var
  Params : TStringList;
  ListList : TTMListList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  if not VarIsNull(aIds) then
    Params.Add('ids=' + VarToStr(aIds));
  if not VarIsNull(aQuery) then
    Params.Add('query=' + VarToStr(aQuery));
  try
    ListList := TTMListList.FromJSON(RetrieveData(Self.FBaseUrl + 'lists', Params).Body);
  finally
    Result := ListList;
  end;
  Params.Free;
end;

/// <summary>
///   Create a new list from the submitted data
/// </summary>
/// <param name="aName">
///   List name
/// </param>
/// <param name="aDescription">
///   List description
/// </param>
/// <param name="aShared">
///   Should this list be shared with sub-accounts
/// </param>
/// <returns>
///   TTMLinkResult
/// </returns>
function TTMClient.CreateList(aName, aDescription : Variant; aShared : Boolean) : TTMLinkResult;
var
  Params : TStringList;
  LinkResult : TTMLinkResult;
begin
  Params := TStringList.Create;

  Params.Add('name=' + VarToStr(aName));
  Params.Add('description=' + VarToStr(aDescription));
  if aShared then
    Params.Add('shared=1')
  else
    Params.Add('shared=0');
  try
    LinkResult := TTMLinkResult.FromJSON(CreateData(Self.FBaseUrl + 'lists', Params).Body);
  finally
    Result := LinkResult;
  end;
  Params.Free;
end;

/// <summary>
///   Create a new list from the submitted data
/// </summary>
/// <param name="aName">
///   List name
/// </param>
/// <returns>
///   TTMLinkResult
/// </returns>
function TTMClient.CreateList(aName : Variant) : TTMLinkResult;
begin
  Result := CreateList(aName, null, false);
end;

/// <summary>
///   Update existing list
/// </summary>
/// <param name="aList">
///   List model
/// </param>
/// <returns>
///   TTMLinkResult
/// </returns>
function TTMClient.UpdateList(aList : TTMList) : TTMLinkResult;
var
  Params : TStringList;
  LinkResult : TTMLinkResult;
begin
  Params := TStringList.Create;

  Params.Add('name=' + aList.Name);
  Params.Add('description=' + aList.Description);
  if aList.Shared then
    Params.Add('shared=1')
  else
    Params.Add('shared=0');
  try
    LinkResult := TTMLinkResult.FromJSON(UpdateData(Self.FBaseUrl + 'lists/' + IntToStr(aList.Id), Params).Body);
  finally
    Result := LinkResult;
  end;
  Params.Free;
end;

/// <summary>
///   Delete a single list
/// </summary>
/// <param name="aId">
///   List ID
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteList(aId : Variant) : Boolean;
var
  ResponseCode : Integer;
begin
  try
    ResponseCode := DeleteData(Self.FBaseUrl + 'lists/' + VarToStr(aId), nil).Code;
  finally
    Result := (ResponseCode = 204);
  end;
end;

/// <summary>
///   Delete a single list
/// </summary>
/// <param name="aList">
///   List model
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteList(aList : TTMList) : Boolean;
begin
  Result := DeleteList(aList.Id);
end;

/// <summary>
///   Fetch user contacts by given list id
/// </summary>
/// <param name="aId">
///   List ID
/// </param>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMContactList
/// </returns>
function TTMClient.GetListContacts(aId, aPage, aLimit : Variant) : TTMContactList;
var
  Params : TStringList;
  ContactList : TTMContactList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  try
    ContactList := TTMContactList.FromJSON(RetrieveData(Self.FBaseUrl + 'lists/' + VarToStr(aId) + '/contacts', Params).Body);
  finally
    Result := ContactList;
  end;
  Params.Free;
end;

/// <summary>
///   Fetch user contacts by given list id
/// </summary>
/// <param name="aId">
///   List ID
/// </param>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMContactList
/// </returns>
function TTMClient.GetListContacts(aId, aPage : Variant) : TTMContactList;
begin
  Result := GetListContacts(aId, aPage, null);
end;

/// <summary>
///   Fetch user contacts by given list model
/// </summary>
/// <param name="aList">
///   List model
/// </param>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMContactList
/// </returns>
function TTMClient.GetListContacts(aList : TTMList; aPage, aLimit : Variant) : TTMContactList;
begin
  Result := GetListContacts(aList.Id, aPage, aLimit);
end;

/// <summary>
///   Fetch user contacts by given list model
/// </summary>
/// <param name="aList">
///   List model
/// </param>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMContactList
/// </returns>
function TTMClient.GetListContacts(aList : TTMList; aPage : Variant) : TTMContactList;
begin
  Result := GetListContacts(aList.Id, aPage, null);
end;

/// <summary>
///   Assign contacts to the specified list
/// </summary>
/// <param name="aList">
///   List model
/// </param>
/// <param name="aContacts">
///   Contacts model list
/// </param>
/// <returns>
///   TTMLinkResult
/// </returns>
function TTMClient.AddContactsToList(aList : TTMList; aContacts : TObjectList<TTMContact>) : TTMLinkResult;
var
  I : Integer;
  Str : String;
begin
  Str := '';
  for I := 0 to aContacts.Count - 1 do
  begin
    Str := Str + IntToStr(aContacts.Items[I].Id);
    if I <> aContacts.Count - 1 then
      Str := Str + ',';
  end;
  Result := AddContactsToList(aList.Id, Str);
end;

/// <summary>
///   Assign contacts to the specified list
/// </summary>
/// <param name="aId">
///   List ID
/// </param>
/// <param name="aContacts">
///   Contact IDs
/// </param>
/// <returns>
///   TTMLinkResult
/// </returns>
function TTMClient.AddContactsToList(aId, aContacts : Variant) : TTMLinkResult;
var
  Params : TStringList;
  LinkResult : TTMLinkResult;
begin
  Params := TStringList.Create;

  if not VarIsNull(aContacts) then
    Params.Add('contacts=' + VarToStr(aContacts));
  try
    LinkResult := TTMLinkResult.FromJSON(UpdateData(Self.FBaseUrl + 'lists/' + VarToStr(aId) + '/contacts', Params).Body);
  finally
    Result := LinkResult;
  end;
  Params.Free;
end;

/// <summary>
///   Unassign contacts from the specified list
/// </summary>
/// <param name="aList">
///   List model
/// </param>
/// <param name="aContacts">
///   Contacts model list
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteContactsFromList(aList : TTMList; aContacts : TObjectList<TTMContact>) : Boolean;
var
  I : Integer;
  Str : String;
begin
  Str := '';
  for I := 0 to aContacts.Count - 1 do
  begin
    Str := Str + IntToStr(aContacts.Items[I].Id);
    if I <> aContacts.Count - 1 then
      Str := Str + ',';
  end;
  Result := DeleteContactsFromList(aList.Id, Str);
end;

/// <summary>
///   Unassign contacts from the specified list
/// </summary>
/// <param name="aId">
///   List ID
/// </param>
/// <param name="aContacts">
///   Contact IDs
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteContactsFromList(aId, aContacts : Variant) : Boolean;
var
  Params : TStringList;
  ResponseCode : Integer;
begin
  Params := TStringList.Create;

  if not VarIsNull(aContacts) then
    Params.Add('contacts=' + VarToStr(aContacts));
  try
    ResponseCode := DeleteData(Self.FBaseUrl + 'lists/' + VarToStr(aId) + '/contacts', Params).Code;
  finally
    Result := (ResponseCode = 204);
  end;
  Params.Free;
end;

/// <summary>
///   Get single user outbound message
/// </summary>
/// <param name="aId">
///   Message ID
/// </param>
/// <returns>
///   TTMMessage
/// </returns>
function TTMClient.GetMessage(aId : Variant) : TTMMessage;
var
  Message : TTMMessage;
begin
  try
    Message := TTMMessage.FromJSON(RetrieveData(Self.FBaseUrl + 'messages/' + VarToStr(aId), nil).Body);
  finally
    Result := Message;
  end;
end;

/// <summary>
///   Get all user oubound messages
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMMessageList
/// </returns>
function TTMClient.GetMessages(aPage, aLimit : Variant) : TTMMessageList;
var
  Params : TStringList;
  MessageList : TTMMessageList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  try
    MessageList := TTMMessageList.FromJSON(RetrieveData(Self.FBaseUrl + 'messages', Params).Body);
  finally
    Result := MessageList;
  end;
  Params.Free;
end;

/// <summary>
///   Get all user oubound messages
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMMessageList
/// </returns>
function TTMClient.GetMessages(aPage : Variant) : TTMMessageList;
begin
  Result := GetMessages(aPage, null);
end;

/// <summary>
///   Find oubound messages by given parameters
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <param name="aIds">
///   Find message by ID(s)
/// </param>
/// <param name="aSessionId">
///   Find messages by session ID
/// </param>
/// <param name="aQuery">
///   Find messages by specified search query
/// </param>
/// <returns>
///   TTMMessageList
/// </returns>
function TTMClient.SearchMessages(aPage, aLimit, aIds, aSessionId, aQuery : Variant) : TTMMessageList;
var
  Params : TStringList;
  MessageList : TTMMessageList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  if not VarIsNull(aIds) then
    Params.Add('ids=' + VarToStr(aIds));
  if not VarIsNull(aSessionId) then
    Params.Add('sessionId=' + VarToStr(aSessionId));
  if not VarIsNull(aQuery) then
    Params.Add('query=' + VarToStr(aQuery));
  try
    MessageList := TTMMessageList.FromJSON(RetrieveData(Self.FBaseUrl + 'messages', Params).Body);
  finally
    Result := MessageList;
  end;
  Params.Free;
end;

/// <summary>
///   Send a new outbound message
/// </summary>
/// <param name="aText">
///   Message text
/// </param>
/// <param name="aTemplateId">
///   Template ID used instead of message text
/// </param>
/// <param name="aSendingTime">
///   Message sending time in unix timestamp format
/// </param>
/// <param name="aContactIds">
///   Contact IDs
/// </param>
/// <param name="aListIds">
///   List IDs
/// </param>
/// <param name="aPhones">
///   Phones
/// </param>
/// <param name="aCutExtra">
///   Should sending method cut extra characters which not fit supplied parts_count
/// </param>
/// <param name="aPartsCount">
///   Maximum message parts count
/// </param>
/// <param name="aReferenceId">
///   Custom message reference id which can be used in your application infrastructure
/// </param>
/// <param name="aFrom">
///   One of allowed Sender ID
/// </param>
/// <param name="aRrule">
///   iCal RRULE parameter to create recurrent scheduled messages
/// </param>
/// <returns>
///   TTMMessageResult
/// </returns>
function TTMClient.CreateMessage(aText, aTemplateId, aSendingTime, aContactIds, aListIds, aPhones, aCutExtra, aPartsCount, aReferenceId, aFrom, aRrule : Variant) : TTMMessageResult;
var
  Params : TStringList;
  MessageResult : TTMMessageResult;
begin
  Params := TStringList.Create;

  if not VarIsNull(aText) then
    Params.Add('text=' + VarToStr(aText));
  if not VarIsNull(aTemplateId) then
    Params.Add('templateId=' + VarToStr(aTemplateId));
  if not VarIsNull(aSendingTime) then
    Params.Add('sendingTime=' + VarToStr(aSendingTime));
  if not VarIsNull(aContactIds) then
    Params.Add('contacts=' + VarToStr(aContactIds));
  if not VarIsNull(aListIds) then
    Params.Add('lists=' + VarToStr(aListIds));
  if not VarIsNull(aPhones) then
    Params.Add('phones=' + VarToStr(aPhones));
  if not VarIsNull(aCutExtra) then
    Params.Add('cutExtra=' + VarToStr(aCutExtra));
  if not VarIsNull(aPartsCount) then
    Params.Add('partsCount=' + VarToStr(aPartsCount));
  if not VarIsNull(aReferenceId) then
    Params.Add('referenceId=' + VarToStr(aReferenceId));
  if not VarIsNull(aFrom) then
    Params.Add('from=' + VarToStr(aFrom));
  if not VarIsNull(aRrule) then
    Params.Add('rrule=' + VarToStr(aRrule));
  try
    MessageResult := TTMMessageResult.FromJSON(CreateData(Self.FBaseUrl + 'messages', Params).Body);
  finally
    Result := MessageResult;
  end;
  Params.Free;
end;

/// <summary>
///   Check pricing for outbound message(s)
/// </summary>
/// <param name="aText">
///   Message text
/// </param>
/// <param name="aTemplateId">
///   Template ID used instead of message text
/// </param>
/// <param name="aSendingTime">
///   Message sending time in unix timestamp format
/// </param>
/// <param name="aContactIds">
///   Contact IDs
/// </param>
/// <param name="aListIds">
///   List IDs
/// </param>
/// <param name="aPhones">
///   Phones
/// </param>
/// <param name="aCutExtra">
///   Should sending method cut extra characters which not fit supplied parts_count
/// </param>
/// <param name="aPartsCount">
///   Maximum message parts count
/// </param>
/// <param name="aReferenceId">
///   Custom message reference id which can be used in your application infrastructure
/// </param>
/// <param name="aFrom">
///   One of allowed Sender ID
/// </param>
/// <param name="aRrule">
///   iCal RRULE parameter to create recurrent scheduled messages
/// </param>
/// <returns>
///   TTMMessagePriceResult
/// </returns>
function TTMClient.GetPrice(aText, aTemplateId, aSendingTime, aContactIds, aListIds, aPhones, aCutExtra, aPartsCount, aReferenceId, aFrom, aRrule : Variant) : TTMMessagePriceResult;
var
  Params : TStringList;
  MessagePrice : TTMMessagePriceResult;
begin
  Params := TStringList.Create;

  if not VarIsNull(aText) then
    Params.Add('text=' + VarToStr(aText));
  if not VarIsNull(aTemplateId) then
    Params.Add('templateId=' + VarToStr(aTemplateId));
  if not VarIsNull(aSendingTime) then
    Params.Add('sendingTime=' + VarToStr(aSendingTime));
  if not VarIsNull(aContactIds) then
    Params.Add('contacts=' + VarToStr(aContactIds));
  if not VarIsNull(aListIds) then
    Params.Add('lists=' + VarToStr(aListIds));
  if not VarIsNull(aPhones) then
    Params.Add('phones=' + VarToStr(aPhones));
  if not VarIsNull(aCutExtra) then
    Params.Add('cutExtra=' + VarToStr(aCutExtra));
  if not VarIsNull(aPartsCount) then
    Params.Add('partsCount=' + VarToStr(aPartsCount));
  if not VarIsNull(aReferenceId) then
    Params.Add('referenceId=' + VarToStr(aReferenceId));
  if not VarIsNull(aFrom) then
    Params.Add('from=' + VarToStr(aFrom));
  if not VarIsNull(aRrule) then
    Params.Add('rrule=' + VarToStr(aRrule));
  Params.Add('dummy=1');
  try
    MessagePrice := TTMMessagePriceResult.FromJSON(CreateData(Self.FBaseUrl + 'messages', Params).Body);
  finally
    Result := MessagePrice;
  end;
  Params.Free;
end;

/// <summary>
///   Delete a single message
/// </summary>
/// <param name="aId">
///   Message ID
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteMessage(aId : Variant) : Boolean;
var
  ResponseCode : Integer;
begin
  try
    ResponseCode := DeleteData(Self.FBaseUrl + 'messages/' + VarToStr(aId), nil).Code;
  finally
    Result := (ResponseCode = 204);
  end;
end;

/// <summary>
///   Delete a single message
/// </summary>
/// <param name="aMessage">
///   Message model
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteMessage(aMessage : TTMMessage) : Boolean;
begin
  Result := DeleteMessage(aMessage.Id);
end;

/// <summary>
///   Get all user chats
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMChatList
/// </returns>
function TTMClient.GetChats(aPage, aLimit : Variant) : TTMChatList;
var
  Params : TStringList;
  ChatList : TTMChatList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  try
    ChatList := TTMChatList.FromJSON(RetrieveData(Self.FBaseUrl + 'chats', Params).Body);
  finally
    Result := ChatList;
  end;
  Params.Free;
end;

/// <summary>
///   Get all user chats
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMChatList
/// </returns>
function TTMClient.GetChats(aPage : Variant) : TTMChatList;
begin
  Result := GetChats(aPage, null);
end;

/// <summary>
///   Fetch messages from chat with specified phone number
/// </summary>
/// <param name="aPhone">
///   Phone number
/// </param>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMChatMessageList
/// </returns>
function TTMClient.GetChatMessages(aPhone, aPage, aLimit : Variant) : TTMChatMessageList;
var
  Params : TStringList;
  ChatMessageList : TTMChatMessageList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  try
    ChatMessageList := TTMChatMessageList.FromJSON(RetrieveData(Self.FBaseUrl + 'chats/' + VarToStr(aPhone), Params).Body);
  finally
    Result := ChatMessageList;
  end;
  Params.Free;
end;

/// <summary>
///   Fetch messages from chat with specified phone number
/// </summary>
/// <param name="aPhone">
///   Phone number
/// </param>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMChatMessageList
/// </returns>
function TTMClient.GetChatMessages(aPhone, aPage : Variant) : TTMChatMessageList;
begin
  Result := GetChatMessages(aPhone, aPage, null);
end;

/// <summary>
///   Get single bulk session
/// </summary>
/// <param name="aId">
///   Bulk session ID
/// </param>
/// <returns>
///   TTMBulkSession
/// </returns>
function TTMClient.GetBulkSession(aId : Variant) : TTMBulkSession;
var
  BulkSession : TTMBulkSession;
begin
  try
    BulkSession := TTMBulkSession.FromJSON(RetrieveData(Self.FBaseUrl + 'bulks/' + VarToStr(aId), nil).Body);
  finally
    Result := BulkSession;
  end;
end;

/// <summary>
///   Get all bulk sending sessions
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMBulkSessionList
/// </returns>
function TTMClient.GetBulkSessions(aPage, aLimit : Variant) : TTMBulkSessionList;
var
  Params : TStringList;
  BulkSessionList : TTMBulkSessionList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  try
    BulkSessionList := TTMBulkSessionList.FromJSON(RetrieveData(Self.FBaseUrl + 'bulks', Params).Body);
  finally
    Result := BulkSessionList;
  end;
  Params.Free;
end;

/// <summary>
///   Get all bulk sending sessions
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMBulkSessionList
/// </returns>
function TTMClient.GetBulkSessions(aPage : Variant) : TTMBulkSessionList;
begin
  Result := GetBulkSessions(aPage, null);
end;

/// <summary>
///   Get single session
/// </summary>
/// <param name="aId">
///   Session ID
/// </param>
/// <returns>
///   TTMSession
/// </returns>
function TTMClient.GetSession(aId : Variant) : TTMSession;
var
  Session : TTMSession;
begin
  try
    Session := TTMSession.FromJSON(RetrieveData(Self.FBaseUrl + 'sessions/' + VarToStr(aId), nil).Body);
  finally
    Result := Session;
  end;
end;

/// <summary>
///   Get all sending sessions
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMSessionList
/// </returns>
function TTMClient.GetSessions(aPage, aLimit : Variant) : TTMSessionList;
var
  Params : TStringList;
  SessionList : TTMSessionList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  try
    SessionList := TTMSessionList.FromJSON(RetrieveData(Self.FBaseUrl + 'sessions', Params).Body);
  finally
    Result := SessionList;
  end;
  Params.Free;
end;

/// <summary>
///   Get all sending sessions
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMSessionList
/// </returns>
function TTMClient.GetSessions(aPage : Variant) : TTMSessionList;
begin
  Result := GetSessions(aPage, null);
end;

/// <summary>
///   Get all session messages
/// </summary>
/// <param name="aId">
///   Session ID
/// </param>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMMessageList
/// </returns>
function TTMClient.GetSessionMessages(aId, aPage, aLimit : Variant) : TTMMessageList;
var
  Params : TStringList;
  MessageList : TTMMessageList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  try
    MessageList := TTMMessageList.FromJSON(RetrieveData(Self.FBaseUrl + 'sessions/' + VarToStr(aId) + '/messages', Params).Body);
  finally
    Result := MessageList;
  end;
  Params.Free;
end;

/// <summary>
///   Get all session messages
/// </summary>
/// <param name="aId">
///   Session ID
/// </param>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMMessageList
/// </returns>
function TTMClient.GetSessionMessages(aId, aPage : Variant) : TTMMessageList;
begin
  Result := GetSessionMessages(aId, aPage, null);
end;

/// <summary>
///   Delete a single session
/// </summary>
/// <param name="aId">
///   Session ID
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteSession(aId : Variant) : Boolean;
var
  ResponseCode : Integer;
begin
  try
    ResponseCode := DeleteData(Self.FBaseUrl + 'sessions/' + VarToStr(aId), nil).Code;
  finally
    Result := (ResponseCode = 204);
  end;
end;

/// <summary>
///   Delete a single session
/// </summary>
/// <param name="aSession">
///   Session model
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteSession(aSession : TTMSession) : Boolean;
begin
  Result := DeleteSession(aSession.Id);
end;

/// <summary>
///
/// </summary>
/// <param name="">
///
/// </param>
/// <returns>
///   TTMSchedule
/// </returns>
function TTMClient.GetSchedule(aId : Variant) : TTMSchedule;
var
  Schedule : TTMSchedule;
begin
  try
    Schedule := TTMSchedule.FromJSON(RetrieveData(Self.FBaseUrl + 'schedules/' + VarToStr(aId), nil).Body);
  finally
    Result := Schedule;
  end;
end;

/// <summary>
///   Get user scheduled messages
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMScheduleList
/// </returns>
function TTMClient.GetSchedules(aPage, aLimit : Variant) : TTMScheduleList;
var
  Params : TStringList;
  ScheduleList : TTMScheduleList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  try
    ScheduleList := TTMScheduleList.FromJSON(RetrieveData(Self.FBaseUrl + 'schedules', Params).Body);
  finally
    Result := ScheduleList;
  end;
  Params.Free;
end;

/// <summary>
///   Get user scheduled messages
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMScheduleList
/// </returns>
function TTMClient.GetSchedules(aPage : Variant) : TTMScheduleList;
begin
  Result := GetSchedules(aPage, null);
end;

/// <summary>
///   Delete single scheduled message
/// </summary>
/// <param name="aId">
///   Message ID
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteSchedule(aId : Variant) : Boolean;
var
  ResponseCode : Integer;
begin
  try
    ResponseCode := DeleteData(Self.FBaseUrl + 'schedules/' + VarToStr(aId), nil).Code;
  finally
    Result := (ResponseCode = 204);
  end;
end;

/// <summary>
///   Delete single scheduled message
/// </summary>
/// <param name="aSchedule">
///   Message model
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteSchedule(aSchedule : TTMSchedule) : Boolean;
begin
  Result := DeleteSchedule(aSchedule.Id);
end;

/// <summary>
///   Get single user inbound message
/// </summary>
/// <param name="aId">
///   Message ID
/// </param>
/// <returns>
///   TTMReply
/// </returns>
function TTMClient.GetReply(aId : Variant) : TTMReply;
var
  Reply : TTMReply;
begin
  try
    Reply := TTMReply.FromJSON(RetrieveData(Self.FBaseUrl + 'replies/' + VarToStr(aId), nil).Body);
  finally
    Result := Reply;
  end;
end;

/// <summary>
///   Get all user inbound messages
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMReplyList
/// </returns>
function TTMClient.GetReplies(aPage, aLimit : Variant) : TTMReplyList;
var
  Params : TStringList;
  ReplyList : TTMReplyList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  try
    ReplyList := TTMReplyList.FromJSON(RetrieveData(Self.FBaseUrl + 'replies', Params).Body);
  finally
    Result := ReplyList;
  end;
  Params.Free;
end;

/// <summary>
///   Get all user inbound messages
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMReplyList
/// </returns>
function TTMClient.GetReplies(aPage : Variant) : TTMReplyList;
begin
  Result := GetReplies(aPage, null);
end;

/// <summary>
///   Find inbound messages by given parameters
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <param name="aIds">
///   Find message by ID(s)
/// </param>
/// <param name="aQuery">
///   Find messages by specified search query
/// </param>
/// <returns>
///   TTMReplyList
/// </returns>
function TTMClient.SearchReplies(aPage, aLimit, aIds, aQuery : Variant) : TTMReplyList;
var
  Params : TStringList;
  ReplyList : TTMReplyList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  if not VarIsNull(aIds) then
    Params.Add('ids=' + VarToStr(aIds));
  if not VarIsNull(aQuery) then
    Params.Add('query=' + VarToStr(aQuery));
  try
    ReplyList := TTMReplyList.FromJSON(RetrieveData(Self.FBaseUrl + 'replies', Params).Body);
  finally
    Result := ReplyList;
  end;
  Params.Free;
end;

/// <summary>
///   Delete single inbound message
/// </summary>
/// <param name="aId">
///   Message ID
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteReply(aId : Variant) : Boolean;
var
  ResponseCode : Integer;
begin
  try
    ResponseCode := DeleteData(Self.FBaseUrl + 'replies/' + VarToStr(aId), nil).Code;
  finally
    Result := (ResponseCode = 204);
  end;
end;

/// <summary>
///   Delete single inbound message
/// </summary>
/// <param name="aReply">
///   Message model
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteReply(aReply : TTMReply) : Boolean;
begin
  Result := DeleteReply(aReply.Id);
end;

/// <summary>
///  Get all account invoices
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMInvoiceList
/// </returns>
function TTMClient.GetInvoices(aPage, aLimit : Variant) : TTMInvoiceList;
var
  Params : TStringList;
  InvoiceList : TTMInvoiceList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  try
    InvoiceList := TTMInvoiceList.FromJSON(RetrieveData(Self.FBaseUrl + 'invoices', Params).Body);
  finally
    Result := InvoiceList;
  end;
  Params.Free;
end;

/// <summary>
///   Get all account invoices
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMInvoiceList
/// </returns>
function TTMClient.GetInvoices(aPage : Variant) : TTMInvoiceList;
begin
  Result := GetInvoices(aPage, null);
end;

/// <summary>
///   Get all available sender settings which could be used in "from" parameter of POST messages method
/// </summary>
/// <param name="aCountry">
///   Country ID
/// </param>
/// <returns>
///   TTMSources
/// </returns>
function TTMClient.GetSources(aCountry : Variant) : TTMSources;
var
  Params : TStringList;
  JSON : ISuperObject;
  FormField : IMember;
  Sources : TTMSources;
begin
  Params := TStringList.Create;
  Sources := TTMSources.Create;

  if not VarIsNull(aCountry) then
    Params.Add('country=' + VarToStr(aCountry));
  try
    JSON := TSuperObject.Create(RetrieveData(Self.FBaseUrl + 'sources', Params).Body);
    for FormField in JSON.A['dedicated'] do
    begin
      Sources.Dedicated.Add(FormField.AsString);
    end;
    for FormField in JSON.A['shared'] do
    begin
      Sources.Shared.Add(FormField.AsString);
    end;
    for FormField in JSON.A['senderIds'] do
    begin
      Sources.SenderIds.Add(FormField.AsString);
    end;
  finally
    Result := Sources;
  end;
  Params.Free;
end;

/// <summary>
///   Get all available sender settings which could be used in "from" parameter of POST messages method
/// </summary>
/// <returns>
///   TTMSources
/// </returns>
function TTMClient.GetSources() : TTMSources;
begin
  Result := GetSources(null);
end;

/// <summary>
///   Get a single dedicated number
/// </summary>
/// <param name="aId">
///   Dedicated number ID
/// </param>
/// <returns>
///   TTMNumber
/// </returns>
function TTMClient.GetNumber(aId : Variant) : TTMNumber;
var
  Number : TTMNumber;
begin
  try
    Number := TTMNumber.FromJSON(RetrieveData(Self.FBaseUrl + 'numbers/' + VarToStr(aId), nil).Body);
  finally
    Result := Number;
  end;
end;

/// <summary>
///   Get all dedicated numbers
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMNumberList
/// </returns>
function TTMClient.GetNumbers(aPage, aLimit : Variant) : TTMNumberList;
var
  Params : TStringList;
  NumberList : TTMNumberList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  try
    NumberList := TTMNumberList.FromJSON(RetrieveData(Self.FBaseUrl + 'numbers', Params).Body);
  finally
    Result := NumberList;
  end;
  Params.Free;
end;

/// <summary>
///   Get all dedicated numbers
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMNumberList
/// </returns>
function TTMClient.GetNumbers(aPage : Variant) : TTMNumberList;
begin
  Result := GetNumbers(aPage, null);
end;

/// <summary>
///   Find available dedicated numbers to buy
/// </summary>
/// <param name="aCountry">
///   Country ID
/// </param>
/// <param name="aPrefix">
///   Desired number prefix. Should include country code (i.e. 447 for GB)
/// </param>
/// <returns>
///   TTMAvailableNumberList
/// </returns>
function TTMClient.GetAvailableNumbers(aCountry, aPrefix : Variant) : TTMAvailableNumberList;
var
  Params : TStringList;
  JSON : ISuperObject;
  FormField : IMember;
  NumberList : TTMAvailableNumberList;
begin
  Params := TStringList.Create;
  NumberList := TTMAvailableNumberList.Create;

  if not VarIsNull(aCountry) then
    Params.Add('country=' + VarToStr(aCountry));
  if not VarIsNull(aPrefix) then
    Params.Add('prefix=' + VarToStr(aPrefix));
  try
    JSON := TSuperObject.Create(RetrieveData(Self.FBaseUrl + 'numbers/available', Params).Body);
    NumberList.Price := JSON.F['price'];
    for FormField in JSON.A['numbers'] do
    begin
      NumberList.Numbers.Add(FormField.AsString);
    end;
  finally
    Result := NumberList;
  end;
  Params.Free;
end;

/// <summary>
///   Find available dedicated numbers to buy
/// </summary>
/// <param name="aCountry">
///   Country ID
/// </param>
/// <returns>
///   TTMAvailableNumberList
/// </returns>
function TTMClient.GetAvailableNumbers(aCountry : Variant) : TTMAvailableNumberList;
begin
  Result := GetAvailableNumbers(aCountry, null);
end;

/// <summary>
///   Buy a dedicated number and assign it to the specified account
/// </summary>
/// <param name="aPhone">
///   Desired dedicated phone number in international E.164 format
/// </param>
/// <param name="aCountry">
///   Country ID
/// </param>
/// <param name="aUserId">
///   Number assignee
/// </param>
/// <returns>
///   TTMLinkResult
/// </returns>
function TTMClient.BuyNumber(aPhone, aCountry, aUserId : Variant) : TTMLinkResult;
var
  Params : TStringList;
  LinkResult : TTMLinkResult;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPhone) then
    Params.Add('phone=' + VarToStr(aPhone));
  if not VarIsNull(aCountry) then
    Params.Add('country=' + VarToStr(aCountry));
  if not VarIsNull(aUserId) then
    Params.Add('userId=' + VarToStr(aUserId));
  try
    LinkResult := TTMLinkResult.FromJSON(CreateData(Self.FBaseUrl + 'numbers', Params).Body);
  finally
    Result := LinkResult;
  end;
  Params.Free;
end;

/// <summary>
///   Cancel dedicated number subscription
/// </summary>
/// <param name="aId">
///   Number ID
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteNumber(aId : Variant) : Boolean;
var
  ResponseCode : Integer;
begin
  try
    ResponseCode := DeleteData(Self.FBaseUrl + 'numbers/' + VarToStr(aId), nil).Code;
  finally
    Result := (ResponseCode = 204);
  end;
end;

/// <summary>
///   Cancel dedicated number subscription
/// </summary>
/// <param name="aNumber">
///   Number model
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteNumber(aNumber : TTMNumber) : Boolean;
begin
  Result := DeleteNumber(aNumber.Id);
end;

/// <summary>
///   Get a single Sender ID
/// </summary>
/// <param name="aId">
///   Sender ID numeric ID
/// </param>
/// <returns>
///   TTMSenderId
/// </returns>
function TTMClient.GetSenderId(aId : Variant) : TTMSenderId;
var
  SenderId : TTMSenderId;
begin
  try
    SenderId := TTMSenderId.FromJSON(RetrieveData(Self.FBaseUrl + 'senderids/' + VarToStr(aId), nil).Body);
  finally
    Result := SenderId;
  end;
end;

/// <summary>
///   Get all user Sender IDs
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMSenderIdList
/// </returns>
function TTMClient.GetSenderIds(aPage, aLimit : Variant) : TTMSenderIdList;
var
  Params : TStringList;
  SenderIdList : TTMSenderIdList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  try
    SenderIdList := TTMSenderIdList.FromJSON(RetrieveData(Self.FBaseUrl + 'senderids', Params).Body);
  finally
    Result := SenderIdList;
  end;
  Params.Free;
end;

/// <summary>
///   Get all user Sender IDs
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMSenderIdList
/// </returns>
function TTMClient.GetSenderIds(aPage : Variant) : TTMSenderIdList;
begin
  Result := GetSenderIds(aPage, null);
end;

/// <summary>
///   Apply for a new Sender ID
/// </summary>
/// <param name="aSenderId">
///   Alphanumeric Sender ID (maximum 11 characters)
/// </param>
/// <param name="aExplanation">
///   Explain why do you need this Sender ID
/// </param>
/// <returns>
///   TTMLinkResult
/// </returns>
function TTMClient.CreateSenderId(aSenderId, aExplanation : Variant) : TTMLinkResult;
var
  Params : TStringList;
  LinkResult : TTMLinkResult;
begin
  Params := TStringList.Create;

  if not VarIsNull(aSenderId) then
    Params.Add('senderId=' + VarToStr(aSenderId));
  if not VarIsNull(aExplanation) then
    Params.Add('explanation=' + VarToStr(aExplanation));
  try
    LinkResult := TTMLinkResult.FromJSON(CreateData(Self.FBaseUrl + 'senderids', Params).Body);
  finally
    Result := LinkResult;
  end;
  Params.Free;
end;

/// <summary>
///   Delete a single Sender ID
/// </summary>
/// <param name="aId">
///   Sender ID numeric ID
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteSenderId(aId : Variant) : Boolean;
var
  ResponseCode : Integer;
begin
  try
    ResponseCode := DeleteData(Self.FBaseUrl + 'senderids/' + VarToStr(aId), nil).Code;
  finally
    Result := (ResponseCode = 204);
  end;
end;

/// <summary>
///   Delete a single Sender ID
/// </summary>
/// <param name="aSenderId">
///   Sender ID model
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.DeleteSenderId(aSenderId : TTMSenderId) : Boolean;
begin
  Result := DeleteSenderId(aSenderId.Id);
end;

/// <summary>
///   Get a single subaccount
/// </summary>
/// <param name="aId">
///   Subaccount ID
/// </param>
/// <returns>
///   TTMUser
/// </returns>
function TTMClient.GetSubaccount(aId : Variant) : TTMUser;
var
  Subaccount : TTMUser;
begin
  try
    Subaccount := TTMUser.FromJSON(RetrieveData(Self.FBaseUrl + 'subaccounts/' + VarToStr(aId), nil).Body);
  finally
    Result := Subaccount;
  end;
end;

/// <summary>
///   Get all subaccounts
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMUserList
/// </returns>
function TTMClient.GetSubaccounts(aPage, aLimit : Variant) : TTMUserList;
var
  Params : TStringList;
  SubaccountList : TTMUserList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  try
    SubaccountList := TTMUserList.FromJSON(RetrieveData(Self.FBaseUrl + 'subaccounts', Params).Body);
  finally
    Result := SubaccountList;
  end;
  Params.Free;
end;

/// <summary>
///   Get all subaccounts
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMUserList
/// </returns>
function TTMClient.GetSubaccounts(aPage : Variant) : TTMUserList;
begin
  Result := GetSubaccounts(aPage, null);
end;

/// <summary>
///   Invite new subaccount
/// </summary>
/// <param name="aEmail">
///   Subaccount email
/// </param>
/// <param name="aRole">
///   Subaccount role
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.InviteSubaccount(aEmail, aRole : Variant) : Boolean;
var
  Params : TStringList;
  ResponseCode : Integer;
begin
  Params := TStringList.Create;

  if not VarIsNull(aEmail) then
    Params.Add('email=' + VarToStr(aEmail));
  if not VarIsNull(aRole) then
    Params.Add('role=' + VarToStr(aRole));
  try
    ResponseCode := CreateData(Self.FBaseUrl + 'subaccounts', Params).Code;
  finally
    Result := (ResponseCode = 204);
  end;
  Params.Free;
end;

/// <summary>
///   Close single subaccount
/// </summary>
/// <param name="aId">
///   Subaccount ID
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.CloseSubaccount(aId : Variant) : Boolean;
var
  ResponseCode : Integer;
begin
  try
    ResponseCode := DeleteData(Self.FBaseUrl + 'subaccounts/' + VarToStr(aId), nil).Code;
  finally
    Result := (ResponseCode = 204);
  end;
end;

/// <summary>
///   Close single subaccount
/// </summary>
/// <param name="aSubaccount">
///   Subaccount model
/// </param>
/// <returns>
///   Boolean
/// </returns>
function TTMClient.CloseSubaccount(aSubaccount : TTMUser) : Boolean;
begin
  Result := CloseSubaccount(aSubaccount.Id);
end;

/// <summary>
///   Return account spending statistics
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <param name="aLimit">
///   How many results to return
/// </param>
/// <returns>
///   TTMStatementList
/// </returns>
function TTMClient.GetStatements(aPage, aLimit : Variant) : TTMStatementList;
var
  Params : TStringList;
  StatementList : TTMStatementList;
begin
  Params := TStringList.Create;

  if not VarIsNull(aPage) then
    Params.Add('page=' + VarToStr(aPage));
  if not VarIsNull(aLimit) then
    Params.Add('limit=' + VarToStr(aLimit));
  try
    StatementList := TTMStatementList.FromJSON(RetrieveData(Self.FBaseUrl + 'stats/spending', Params).Body);
  finally
    Result := StatementList;
  end;
  Params.Free;
end;

/// <summary>
///   Return account spending statistics
/// </summary>
/// <param name="aPage">
///   Fetch specified results page
/// </param>
/// <returns>
///   TTMStatementList
/// </returns>
function TTMClient.GetStatements(aPage : Variant) : TTMStatementList;
begin
  Result := GetStatements(aPage, null);
end;

/// <summary>
///   Get current user info
/// </summary>
/// <returns>
///   TTMUser
/// </returns>
function TTMClient.GetUser() : TTMUser;
var
  User : TTMUser;
begin
  try
    User := TTMUser.FromJSON(RetrieveData(Self.FBaseUrl + 'user', nil).Body);
  finally
    Result := User;
  end;
end;

/// <summary>
///   Update current user info
/// </summary>
/// <param name="aFirstName">
///   Account first name
/// </param>
/// <param name="aLastName">
///   Account last name
/// </param>
/// <param name="aCompany">
///   Account company
/// </param>
/// <returns>
///   TTMLinkResult
/// </returns>
function TTMClient.UpdateUser(aFirstName, aLastName, aCompany : Variant) : TTMLinkResult;
var
  Params : TStringList;
  LinkResult : TTMLinkResult;
begin
  Params := TStringList.Create;

  if not VarIsNull(aFirstName) then
    Params.Add('firstName=' + VarToStr(aFirstName));
  if not VarIsNull(aLastName) then
    Params.Add('lastName=' + VarToStr(aLastName));
  if not VarIsNull(aCompany) then
    Params.Add('company=' + VarToStr(aCompany));
  try
    LinkResult := TTMLinkResult.FromJSON(UpdateData(Self.FBaseUrl + 'user', Params).Body);
  finally
    Result := LinkResult;
  end;
  Params.Free;
end;

/// <summary>
///   Update current user info
/// </summary>
/// <param name="aUser">
///   User model
/// </param>
/// <returns>
///   TTMLinkResult
/// </returns>
function TTMClient.UpdateUser(aUser : TTMUser) : TTMLinkResult;
begin
  Result := UpdateUser(aUser.FirstName, aUser.LastName, aUser.Company);
end;

end.
