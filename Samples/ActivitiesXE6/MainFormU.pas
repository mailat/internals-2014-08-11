unit MainFormU;

interface

uses
  System.Messaging,
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  Androidapi.JNI.GraphicsContentViewText, FMX.ListBox, FMX.Edit, FMX.StdCtrls,
  FMX.Layouts;

type
  TMainForm = class(TForm)
    Layout: TLayout;
    TelNoButton: TButton;
    BatteryUsageButton: TButton;
    WebURLButton: TButton;
    MapURLButton: TButton;
    StreetViewURLButton: TButton;
    ContactsButton: TButton;
    SMSButton: TButton;
    EmailButton: TButton;
    BarcodeScannerButton: TButton;
    VertScrollBox: TVertScrollBox;
    procedure TelNoButtonClick(Sender: TObject);
    procedure BatteryUsageButtonClick(Sender: TObject);
    procedure BarcodeScannerButtonClick(Sender: TObject);
    procedure WebURLButtonClick(Sender: TObject);
    procedure MapURLButtonClick(Sender: TObject);
    procedure StreetViewURLButtonClick(Sender: TObject);
    procedure ContactsButtonClick(Sender: TObject);
    procedure SMSButtonClick(Sender: TObject);
    procedure EmailButtonClick(Sender: TObject);
  private
  { Private declarations }
    const
    ScanRequestCode = 0;

  var
    FMessageSubscriptionID: Integer;
    procedure HandleActivityMessage(const Sender: TObject; const M: TMessage);
    function OnActivityResult(RequestCode, ResultCode: Integer; Data: JIntent): Boolean;
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

uses
  FMX.Platform.Android,
  Androidapi.Helpers,
  Androidapi.JNI.App,
  Androidapi.JNI.Toast,
  LaunchActivities;

{$R *.fmx}
{ TMainForm }

procedure TMainForm.BatteryUsageButtonClick(Sender: TObject);
begin
  ShowBatteryUsage
end;

procedure TMainForm.ContactsButtonClick(Sender: TObject);
begin
  LaunchUrl('content://contacts/people')
end;

procedure TMainForm.EmailButtonClick(Sender: TObject);
begin
  CreateEmail(['foo@bar.com'], 'Important Info', 'O HAI!')
end;

procedure TMainForm.MapURLButtonClick(Sender: TObject);
begin
  LaunchUrl('geo:37.422,-122.084?z=17')
end;

procedure TMainForm.SMSButtonClick(Sender: TObject);
begin
  CreateSMS('123456789', 'O HAI!')
end;

procedure TMainForm.StreetViewURLButtonClick(Sender: TObject);
begin
  LaunchUrl('google.streetview:cbll=37.422044,-122.083849&cbp=12,7.59,,0,-34.22&mz=21')
end;

procedure TMainForm.TelNoButtonClick(Sender: TObject);
begin
  LaunchUrl('tel:123456789')
end;

procedure TMainForm.WebURLButtonClick(Sender: TObject);
begin
  LaunchUrl('http://www.embarcadero.com/delphi')
end;

procedure TMainForm.BarcodeScannerButtonClick(Sender: TObject);
begin
  FMessageSubscriptionID := TMessageManager.DefaultManager.SubscribeToMessage(TMessageResultNotification,
    HandleActivityMessage);
  LaunchQRScanner(ScanRequestCode);
end;

procedure TMainForm.HandleActivityMessage(const Sender: TObject; const M: TMessage);
begin
  if M is TMessageResultNotification then
    OnActivityResult(TMessageResultNotification(M).RequestCode, TMessageResultNotification(M).ResultCode,
      TMessageResultNotification(M).Value);
end;

function TMainForm.OnActivityResult(RequestCode, ResultCode: Integer; Data: JIntent): Boolean;
var
  ScanContent, ScanFormat: string;
begin
  Result := False;

  TMessageManager.DefaultManager.Unsubscribe(TMessageResultNotification, FMessageSubscriptionID);
  FMessageSubscriptionID := 0;

  // For more info see https://github.com/zxing/zxing/wiki/Scanning-Via-Intent
  if RequestCode = ScanRequestCode then
  begin
    if ResultCode = TJActivity.JavaClass.RESULT_OK then
    begin
      if Assigned(Data) then
      begin
        ScanContent := JStringToString(Data.getStringExtra(StringToJString('SCAN_RESULT')));
        ScanFormat := JStringToString(Data.getStringExtra(StringToJString('SCAN_RESULT_FORMAT')));
        Toast(Format('Found %s format barcode:'#10'%s', [ScanFormat, ScanContent]), LongToast);
      end;
    end
    else if ResultCode = TJActivity.JavaClass.RESULT_CANCELED then
    begin
      Toast('You cancelled the scan', ShortToast);
    end;
    Result := True;
  end;
end;

end.
