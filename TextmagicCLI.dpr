program TextmagicCLI;

{$APPTYPE CONSOLE}

{$R *.res}

/// This file is part of the TextmagicRestClient package.
///
/// Copyright (c) 2015 TextMagic Ltd. All rights reserved.
///
/// For the full copyright and license information, please view the LICENSE
/// file that was distributed with this source code.

/// autor Denis <denis@textmagic.biz>

uses
  System.SysUtils, TextmagicRestClient, Windows, System.Classes, Variants;

type
  TProcedure = procedure();

  TMenuItem = record
    Name : String;
    Proc : TProcedure;
  end;

  TMenuItems = array of TMenuItem;
const
  VERSION = '0.01';
var
  /// <summary>
  ///   Client object
  /// </summary>
  Client : TTMClient;

  /// <summary>
  ///   User object
  /// </summary>
  User : TTMUser;

  /// <summary>
  ///   Pagination page
  /// </summary>
  Page : Integer;

  /// <summary>
  ///   Pagination limit
  /// </summary>
  Limit : Integer;

  /// <summary>
  ///   Pagination procedure
  /// </summary>
  PaginatedProcedure : TProcedure;

/// <summary>
///   Error handler
/// </summary>
/// <param name="E">
///   Exception
/// </param>
function Error(E : TMException) : String;
var
  Str : String;
begin
  Result := IntToStr(E.ErrorCode) + ' ' + E.Message + #13#10;

  for Str in E.Errors.Keys do
  begin
    Result := Result + Str + ': ' + E.Errors[Str];
  end;
end;

/// <summary>
///   Read number value
/// </summary>
/// <param name="Text">
///   Read value description
/// </param>
/// <returns>
///   Integer
/// </returns>
function ReadNumber(Text : String) : Integer;
var
  Str : String;
begin
  writeln('');
  writeln(Text);
  readln(Str);
  try
    Result := StrToInt(Str);
  except
    Result := 0;
  end;
end;

/// <summary>
///   Show top user banner
/// </summary>
procedure ShowUserInfo();
begin
  writeln('TextMagic CLI v' + VERSION + ' || ' + User.FirstName + ' ' + User.LastName + ' (' + User.Username + ') || ' + FloatToStr(User.Balance) + ' ' + User.Currency.Id);
end;

/// <summary>
///   Normal program termination
/// </summary>
procedure ExitOk();
begin
  writeln('Bye!');
end;

/// <summary>
///   Go to previous page when browsing paginated resource
/// </summary>
procedure GoToPreviousPage();
begin
  if (Page <= 2) then
    Page := 1
  else
    Dec(Page);
  PaginatedProcedure();
end;

/// <summary>
///   Go to next page when browsing paginated resource
/// </summary>
procedure GoToNextPage();
begin
  Inc(Page);
  PaginatedProcedure();
end;

/// <summary>
///   Reset current page, limit and paginated resource fetch function
/// </summary>
procedure flushPagination();
begin
  Page := 1;
  Limit := 10;
  PaginatedProcedure := @ExitOk;
end;

/// <summary>
///   Show numered menu and return user choice
/// </summary>
procedure ShowMenu(var Items : TMenuItems);
var
  I : Integer;
begin
  writeln('');
  SetLength(Items, Length(Items) + 1);
  Items[Length(Items) - 1].Name := 'Exit';
  Items[Length(Items) - 1].Proc := @ExitOk;
  for I := 0 to Length(Items) - 1 do
  begin
    writeln(IntToStr(I + 1) + '. ' + Items[I].Name);
  end;
  I := ReadNumber('Your choice (' + IntToStr(Length(Items)) + '):');
  if (I > 0) and (I <= Length(Items)) then
  begin
    Items[I - 1].Proc();
  end
  else
  begin
    writeln('');
    ExitOk();
  end;
end;

procedure ShowMainMenu(); forward;

procedure ShowAllContacts(); forward;

/// <summary>
///   Show one contact details
/// </summary>
procedure showContact();
var
  Id : Integer;
  Contact : TTMContact;
begin
  Id := ReadNumber('Enter contact ID');

  if Id > 0 then
  begin
    try
      Contact := Client.GetContact(Id);
    except
      on E: TMException do
      begin
        writeln(Error(E));
        Exit();
      end;
    end;

    writeln('');
    writeln('CONTACT INFORMATION');
    writeln('===================');
    writeln('Name    : ' + Contact.FirstName + ' ' + Contact.LastName);
    writeln('Phone   : +' + Contact.Phone + ' (' + Contact.Country.Name + ')');
    writeln('Company : ' + Contact.CompanyName);
    writeln('');
  end;

  ShowAllContacts();
end;

/// <summary>
///   Delete contact permanently
/// </summary>
procedure deleteContact();
var
  Id : Integer;
begin
  Id := ReadNumber('Enter contact ID');

  if Id > 0 then
  begin
    try
      Client.DeleteContact(Id);
    except
      on E: TMException do
      begin
        writeln(Error(E));
        Exit();
      end;
    end;

    writeln('Contact deleted successfully');
  end;

  ShowAllContacts();
end;

/// <summary>
///   Show all user contacts (including shared)
/// </summary>
procedure ShowAllContacts();
var
  I : Integer;
  Contacts : TTMContactList;
  Items : TMenuItems;
begin
  PaginatedProcedure := @ShowAllContacts;
  try
    Contacts := Client.GetContacts(Page, Limit, 1);
  except
    on E: TMException do
    begin
      writeln(Error(E));
      Exit();
    end;
  end;

  writeln('ALL CONTACTS');
  writeln('============');
  writeln('Page ' + IntToStr(Page) + ' of ' + IntToStr(Limit));
  writeln('');

  for I := 0 to Contacts.Resources.Count - 1 do
  begin
    writeln(IntToStr(Contacts.Resources[I].Id) + '. ' + Contacts.Resources[I].FirstName + ' ' + Contacts.Resources[I].LastName + ', ' + Contacts.Resources[I].Phone);
  end;
  SetLength(Items, 5);
  Items[0].Name := 'Previous page';
  Items[0].Proc := @goToPreviousPage;
  Items[1].Name := 'Next page';
  Items[1].Proc := @goToNextPage;
  Items[2].Name := 'Show contact details';
  Items[2].Proc := @showContact;
  Items[3].Name := 'Delete contact';
  Items[3].Proc := @deleteContact;
  Items[4].Name := 'Back to main menu';
  Items[4].Proc := @ShowMainMenu;
  ShowMenu(Items);
end;

/// <summary>
///   Show all user lists (including shared)
/// </summary>
procedure ShowAllLists();
var
  I : Integer;
  Lists : TTMListList;
  Items : TMenuItems;
begin
  PaginatedProcedure := @ShowAllLists;
  try
    Lists := Client.GetLists(Page, Limit);
  except
    on E: TMException do
    begin
      writeln(Error(E));
      Exit();
    end;
  end;

  writeln('ALL LISTS');
  writeln('============');
  writeln('Page ' + IntToStr(Page) + ' of ' + IntToStr(Limit));
  writeln('');

  for I := 0 to Lists.Resources.Count - 1 do
  begin
    writeln(IntToStr(Lists.Resources[I].Id) + '. ' + Lists.Resources[I].Name + ' ' + Lists.Resources[I].Description);
  end;
  SetLength(Items, 3);
  Items[0].Name := 'Previous page';
  Items[0].Proc := @goToPreviousPage;
  Items[1].Name := 'Next page';
  Items[1].Proc := @goToNextPage;
  Items[2].Name := 'Back to main menu';
  Items[2].Proc := @ShowMainMenu;
  ShowMenu(Items);
end;

procedure ShowMessagesOut(); forward;

/// <summary>
///   Delete one sent message
/// </summary>
procedure deleteMessageOut();
var
  Id : Integer;
begin
  Id := ReadNumber('Enter message ID');

  if Id > 0 then
  begin
    try
      Client.DeleteMessage(Id);
    except
      on E: TMException do
      begin
        writeln(Error(E));
        Exit();
      end;
    end;

    writeln('Message deleted successfully');
  end;

  ShowMessagesOut();
end;

/// <summary>
///   Show all sent messages
/// </summary>
procedure ShowMessagesOut();
var
  I : Integer;
  Messages : TTMMessageList;
  Items : TMenuItems;
begin
  PaginatedProcedure := @showMessagesOut;
  try
    Messages := Client.GetMessages(Page, Limit);
  except
    on E: TMException do
    begin
      writeln(Error(E));
      Exit();
    end;
  end;

  writeln('SENT MESSAGES');
  writeln('============');
  writeln('Page ' + IntToStr(Page) + ' of ' + IntToStr(Limit));
  writeln('');

  for I := 0 to Messages.Resources.Count - 1 do
  begin
    writeln(IntToStr(Messages.Resources[I].Id) + '. ' + Messages.Resources[I].Text + ' (from ' + Messages.Resources[I].Receiver + ')');
  end;
  SetLength(Items, 4);
  Items[0].Name := 'Previous page';
  Items[0].Proc := @goToPreviousPage;
  Items[1].Name := 'Next page';
  Items[1].Proc := @goToNextPage;
  Items[2].Name := 'Delete message';
  Items[2].Proc := @deleteMessageOut;
  Items[3].Name := 'Back to main menu';
  Items[3].Proc := @ShowMainMenu;
  ShowMenu(Items);
end;

procedure ShowMessagesIn(); forward;

/// <summary>
///   Delete one received message
/// </summary>
procedure deleteMessageIn();
var
  Id : Integer;
begin
  Id := ReadNumber('Enter message ID');

  if Id > 0 then
  begin
    try
      Client.DeleteReply(Id);
    except
      on E: TMException do
      begin
        writeln(Error(E));
        Exit();
      end;
    end;

    writeln('Message deleted successfully');
  end;

  ShowMessagesIn();
end;

/// <summary>
///   Show all received messages
/// </summary>
procedure ShowMessagesIn();
var
  I : Integer;
  Replies : TTMReplyList;
  Items : TMenuItems;
begin
  PaginatedProcedure := @ShowMessagesIn;
  try
    Replies := Client.GetReplies(Page, Limit);
  except
    on E: TMException do
    begin
      writeln(Error(E));
      Exit();
    end;
  end;

  writeln('RECEIVED MESSAGES');
  writeln('============');
  writeln('Page ' + IntToStr(Page) + ' of ' + IntToStr(Limit));
  writeln('');

  for I := 0 to Replies.Resources.Count - 1 do
  begin
    writeln(IntToStr(Replies.Resources[I].Id) + '. ' + Replies.Resources[I].Text + ' (from ' + Replies.Resources[I].Sender + ')');
  end;
  SetLength(Items, 4);
  Items[0].Name := 'Previous page';
  Items[0].Proc := @goToPreviousPage;
  Items[1].Name := 'Next page';
  Items[1].Proc := @goToNextPage;
  Items[2].Name := 'Delete message';
  Items[2].Proc := @deleteMessageIn;
  Items[3].Name := 'Back to main menu';
  Items[3].Proc := @ShowMainMenu;
  ShowMenu(Items);
end;

/// <summary>
///   Send outgoing message to phones, contacts and/or contact lists
/// </summary>
procedure SendMessage();
var
  MessageResult : TTMMessageResult;
  Ch : Char;
  SendingPhones,
  SendingContacts,
  SendingList : TStringList;
  SendingText,
  Str : String;
begin
  SendingPhones := TStringList.Create;
  SendingContacts := TStringList.Create;
  SendingList := TStringList.Create;

  writeln('SEND MESSAGE');
  writeln('============');

  writeln('');
  writeln('Text:');
  readln(SendingText);

  writeln('');
  writeln('Enter phone numbers, separated by [ENTER]. Empty string to break.');
  writeln('');
  repeat
    writeln('Phone:');
    readln(Str);
    if Str <> '' then
      SendingPhones.Add(Str);
  until Str = '';

  writeln('');
  writeln('');
  writeln('Enter contact IDs, separated by [ENTER]. Empty string to break.');
  repeat
    Str := IntToStr(ReadNumber('Contact'));
    if Str <> '0' then
      SendingContacts.Add(Str);
  until Str = '0';

  writeln('');
  writeln('');
  writeln('Enter list IDs, separated by [ENTER]. Empty string to break.');
  repeat
    Str := IntToStr(ReadNumber('List'));
    if Str <> '0' then
      SendingList.Add(Str);
  until Str = '0';

  writeln('');
  writeln('');
  writeln('YOU ARE ABOUT TO SEND MESSAGES TO:');
  if SendingPhones.Count > 0 then
  begin
    writeln('');
    writeln('Phone numbers:');
    writeln(SendingPhones.GetText);
  end;
  if SendingContacts.Count > 0 then
  begin
    writeln('');
    writeln('Contacts:');
    writeln(SendingContacts.GetText);
  end;
  if SendingList.Count > 0 then
  begin
    writeln('');
    writeln('Lists:');
    writeln(SendingList.GetText);
  end;

  writeln('Are you sure (y/n)?');
  readln(Ch);
  if UpperCase(Ch) = 'Y' then
  begin
    try
      MessageResult := Client.CreateMessage(
        SendingText,
        null,
        null,
        Copy(StringReplace(SendingContacts.GetText, #13#10, ', ', [rfReplaceAll]), 1, Length(SendingContacts.GetText) - 2),
        Copy(StringReplace(SendingList.GetText, #13#10, ', ', [rfReplaceAll]), 1, Length(SendingList.GetText) - 2),
        Copy(StringReplace(SendingPhones.GetText, #13#10, ', ', [rfReplaceAll]), 1, Length(SendingPhones.GetText) - 2),
        null,
        null,
        null,
        null,
        null);
    except
      on E: TMException do
      begin
        writeln(Error(E));
        Exit();
      end;
    end;
    writeln('');
    writeln('Message ' + IntToStr(MessageResult.Id) + ' sent');
  end;
  SendingPhones.Free;
  SendingContacts.Free;
  SendingList.Free;
  ShowMainMenu();
end;

/// <summary>
///   Show messages menu
/// </summary>
procedure showMessagesMenu();
var
  Items : TMenuItems;
begin
  SetLength(Items, 4);
  Items[0].Name := 'Show outgoing messages';
  Items[0].Proc := @showMessagesOut;
  Items[1].Name := 'Show incoming messages';
  Items[1].Proc := @showMessagesIn;
  Items[2].Name := 'Send message';
  Items[2].Proc := @sendMessage;
  Items[3].Name := 'Back to main menu';
  Items[3].Proc := @ShowMainMenu;
  ShowMenu(Items);
end;

procedure ShowAllTemplates(); forward;

/// <summary>
///   Delete one message template
/// </summary>
procedure deleteTemplate();
var
  Id : Integer;
begin
  Id := ReadNumber('Enter template ID');

  if Id > 0 then
  begin
    try
      Client.DeleteTemplate(Id);
    except
      on E: TMException do
      begin
        writeln(Error(E));
        Exit();
      end;
    end;

    writeln('Template deleted successfully');
  end;

  ShowAllTemplates();
end;

/// <summary>
///   Show all message templates
/// </summary>
procedure ShowAllTemplates();
var
  I : Integer;
  Templates : TTMTemplateList;
  Items : TMenuItems;
begin
  PaginatedProcedure := @ShowAllTemplates;
  try
    Templates := Client.GetTemplates(Page, Limit);
  except
    on E: TMException do
    begin
      writeln(Error(E));
      Exit();
    end;
  end;

  writeln('TEMPLATES');
  writeln('============');
  writeln('Page ' + IntToStr(Page) + ' of ' + IntToStr(Limit));
  writeln('');

  for I := 0 to Templates.Resources.Count - 1 do
  begin
    writeln(IntToStr(Templates.Resources[I].Id) + '. ' + Templates.Resources[I].Name + ' ' + Templates.Resources[I].Content);
  end;
  SetLength(Items, 4);
  Items[0].Name := 'Previous page';
  Items[0].Proc := @goToPreviousPage;
  Items[1].Name := 'Next page';
  Items[1].Proc := @goToNextPage;
  Items[2].Name := 'Delete template';
  Items[2].Proc := @deleteTemplate;
  Items[3].Name := 'Back to main menu';
  Items[3].Proc := @ShowMainMenu;
  ShowMenu(Items);
end;

/// <summary>
///   Show base account information
/// </summary>
procedure showInformation();
var
  Items : TMenuItems;
begin
  writeln('');
  writeln('ACCOUNT INFORMATION');
  writeln('===================');
  writeln('ID          : ' + IntToStr(User.Id));
  writeln('Username    : ' + User.Username);
  writeln('First Name  : ' + User.FirstName);
  writeln('Last Name   : ' + User.LastName);
  writeln('Balance     : ' + FloatToStr(User.Balance) + ' ' + User.Currency.Id);
  writeln('Timezone    : ' + User.Timezone.Timezone);
  SetLength(Items, 1);
  Items[0].Name := 'Back to main menu';
  Items[0].Proc := @ShowMainMenu;
  ShowMenu(Items);
end;

/// <summary>
///   Show main menu
/// </summary>
procedure ShowMainMenu();
var
  Items : TMenuItems;
begin
  flushPagination;
  SetLength(Items, 5);
  Items[0].Name := 'Contacts';
  Items[0].Proc := @ShowAllContacts;
  Items[1].Name := 'Lists';
  Items[1].Proc := @ShowAllLists;
  Items[2].Name := 'Messages';
  Items[2].Proc := @showMessagesMenu;
  Items[3].Name := 'Templates';
  Items[3].Proc := @showAllTemplates;
  Items[4].Name := 'Information';
  Items[4].Proc := @showInformation;
  ShowMenu(Items);
end;

/// <summary>
///   Clear console screen
/// </summary>
procedure ClrScr;
var
  STDOUT : THandle;
  CSBI : TConsoleScreenBufferInfo;
  ConsoleSize : DWORD;
  NumWritten : DWORD;
  Origin : TCoord;
begin
  STDOUT := GetStdHandle(STD_OUTPUT_HANDLE);
  Win32Check(STDOUT <> INVALID_HANDLE_VALUE);
  Win32Check(GetConsoleScreenBufferInfo(STDOUT, CSBI));
  ConsoleSize := CSBI.dwSize.X * CSBI.dwSize.Y;
  Origin.X := 0;
  Origin.Y := 0;
  Win32Check(FillConsoleOutputCharacter(STDOUT, ' ', ConsoleSize, Origin, NumWritten));
  Win32Check(FillConsoleOutputAttribute(STDOUT, csbi.wAttributes, ConsoleSize, Origin, NumWritten));
  Win32Check(SetConsoleCursorPosition(STDOUT, Origin));
end;

/// <summary>
///   Main program procedure
/// </summary>
begin
  Client := TTMClient.Create('<USERNAME>', '<APIV2_TOKEN>');
  try
    User := Client.GetUser();
  except
    on E: TMException do
    begin
      writeln(Error(E));
      Exit();
    end;
  end;
  ShowUserInfo();
  ShowMainMenu();
end.
