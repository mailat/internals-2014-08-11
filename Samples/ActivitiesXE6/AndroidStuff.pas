unit AndroidStuff;

interface

function HasPermission(const Permission: string): Boolean;
procedure SendSMS(const Number, Msg: string);

implementation

uses
  System.UITypes,
  FMX.Dialogs,
  FMX.Helpers.Android,
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Telephony;

function HasPermission(const Permission: string): Boolean;
begin
  //Permissions listed at http://d.android.com/reference/android/Manifest.permission.html
  Result := SharedActivity.checkCallingOrSelfPermission(
    StringToJString(Permission)) =
    TJPackageManager.JavaClass.PERMISSION_GRANTED
end;

procedure SendSMS(const Number, Msg: string);
var
  SmsManager: JSmsManager;
begin
  if not HasPermission('android.permission.SEND_SMS') then
    MessageDlg('App does not have the SEND_SMS permission',
      TMsgDlgType.mtError, [TMsgDlgBtn.mbCancel], 0)
  else
  begin
    SmsManager := TJSmsManager.JavaClass.getDefault;
    SmsManager.sendTextMessage(
      StringToJString(Number),
      nil,
      StringToJString(Msg),
      nil,
      nil);
  end;
end;

end.
