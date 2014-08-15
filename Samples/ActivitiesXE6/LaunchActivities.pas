unit LaunchActivities;

interface

procedure ShowBatteryUsage;
procedure LaunchURL(const URL: string);
procedure CreateSMS(const Number, Msg: string);
procedure CreateEmail(const Recipient, Subject, Content: string); overload;
procedure CreateEmail(const Recipients: array of string; const Subject, Content: string); overload;
procedure LaunchQRScanner(RequestCode: Integer);

implementation

uses
  System.SysUtils,
  FMX.Helpers.Android,
  Androidapi.Helpers,
  Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Net,
  Androidapi.JNI.Toast;

function LaunchActivity(const Intent: JIntent): Boolean; overload;
var
  ResolveInfo: JResolveInfo;
begin
  ResolveInfo := SharedActivity.getPackageManager.resolveActivity(Intent, 0);
  Result := ResolveInfo <> nil;
  if Result then
    SharedActivity.startActivity(Intent);
end;

function LaunchActivity(const Action: JString): Boolean; overload;
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(Action);
  Result := LaunchActivity(Intent);
end;

function LaunchActivity(const Action: JString; const URI: Jnet_Uri): Boolean; overload;
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(Action, URI);
  Result := LaunchActivity(Intent);
end;

function LaunchActivityForResult(const Intent: JIntent; RequestCode: Integer): Boolean;
var
  ResolveInfo: JResolveInfo;
begin
  ResolveInfo := SharedActivity.getPackageManager.resolveActivity(Intent, 0);
  Result := ResolveInfo <> nil;
  if Result then
    SharedActivity.startActivityForResult(Intent, RequestCode);
end;

procedure ShowBatteryUsage;
begin
  if not LaunchActivity(TJIntent.JavaClass.ACTION_POWER_USAGE_SUMMARY) then
    Toast('Cannot display battery usage', ShortToast)
end;

procedure LaunchURL(const URL: string);
begin
  LaunchActivity(TJIntent.JavaClass.ACTION_VIEW, StrToJURI(URL));
end;

procedure CreateSMS(const Number, Msg: string);
var
  Intent: JIntent;
  URI: Jnet_Uri;
begin
  URI := StrToJURI(Format('smsto:%s', [Number]));
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW, URI);
  Intent.putExtra(StringToJString('sms_body'), StringToJString(Msg));
  LaunchActivity(Intent);
end;

procedure CreateEmail(const Recipient, Subject, Content: string);
var
  Intent: JIntent;
  JRecipients: TJavaObjectArray<JString>;
begin
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_SEND);
  JRecipients := TJavaObjectArray<JString>.Create(1);
  JRecipients.Items[0] := StringToJString(Recipient);
  Intent.putExtra(TJIntent.JavaClass.EXTRA_EMAIL, JRecipients);
  Intent.putExtra(TJIntent.JavaClass.EXTRA_SUBJECT, StringToJString(Subject));
  Intent.putExtra(TJIntent.JavaClass.EXTRA_TEXT, StringToJString(Content));
  // Intent.setType(StringToJString('plain/text'));
  Intent.setType(StringToJString('message/rfc822'));
  // LaunchActivity(Intent);
  LaunchActivity(TJIntent.JavaClass.createChooser(Intent, StrToJCharSequence('Which email app?')));
end;

procedure CreateEmail(const Recipients: array of string; const Subject, Content: string); overload;
var
  Intent: JIntent;
  I: Integer;
  JRecipients: TJavaObjectArray<JString>;
begin
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_SEND);
  JRecipients := TJavaObjectArray<JString>.Create(Length(Recipients));
  for I := 0 to Pred(Length(Recipients)) do
    JRecipients.Items[I] := StringToJString(Recipients[I]);
  Intent.putExtra(TJIntent.JavaClass.EXTRA_EMAIL, JRecipients);
  Intent.putExtra(TJIntent.JavaClass.EXTRA_SUBJECT, StringToJString(Subject));
  Intent.putExtra(TJIntent.JavaClass.EXTRA_TEXT, StringToJString(Content));
  // Intent.setType(StringToJString('plain/text'));
  Intent.setType(StringToJString('message/rfc822'));
  // LaunchActivity(Intent);
  LaunchActivity(TJIntent.JavaClass.createChooser(Intent, StrToJCharSequence('Which email app?')));
end;

//For more info see https://github.com/zxing/zxing/wiki/Scanning-Via-Intent
procedure LaunchQRScanner(RequestCode: Integer);
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(StringToJString('com.google.zxing.client.android.SCAN'));
  Intent.setPackage(StringToJString('com.google.zxing.client.android'));
  // If you want to target QR codes
  //Intent.putExtra(StringToJString('SCAN_MODE'), StringToJString('QR_CODE_MODE'));
  if not LaunchActivityForResult(Intent, RequestCode) then
    Toast('Cannot display QR scanner', ShortToast);
end;

end.
