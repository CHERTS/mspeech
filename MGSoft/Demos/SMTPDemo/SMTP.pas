unit SMTP;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MGSMTP, Vcl.StdCtrls, blcksock;

type
  TMainForm = class(TForm)
    MGSMTP1: TMGSMTP;
    LHost: TLabel;
    LPort: TLabel;
    LLogin: TLabel;
    EHost: TEdit;
    EPort: TEdit;
    ELogin: TEdit;
    LPasswd: TLabel;
    EPasswd: TEdit;
    CBTLS: TCheckBox;
    LFrom: TLabel;
    EFrom: TEdit;
    MemoText: TMemo;
    LText: TLabel;
    ButtonSend: TButton;
    MemoLog: TMemo;
    LLog: TLabel;
    CBFullSSL: TCheckBox;
    ETo: TEdit;
    LTo: TLabel;
    procedure ButtonSendClick(Sender: TObject);
    procedure MGSMTP1Status(Sender: TObject; Reason: THookSocketReason;
      const Value: string);
    procedure FormCreate(Sender: TObject);
    procedure MGSMTP1ReadFilter(Sender: TObject; var Value: AnsiString);
    procedure CBFullSSLClick(Sender: TObject);
    procedure CBTLSClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.CBFullSSLClick(Sender: TObject);
begin
  if (Sender as TCheckBox).Checked then
    EPort.Text := '465'
  else
  begin
    if CBTLS.Checked then
      EPort.Text := '587'
    else
      EPort.Text := '25';
  end;
end;

procedure TMainForm.CBTLSClick(Sender: TObject);
begin
  if (Sender as TCheckBox).Checked then
  begin
    if CBFullSSL.Checked then
      EPort.Text := '465'
    else
      EPort.Text := '587';
  end
  else
  begin
    if CBFullSSL.Checked then
      EPort.Text := '465'
    else
      EPort.Text := '25';
  end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  EHost.Text := 'smtp.yandex.ru';
  EPort.Text := '587';
  ELogin.Text := 'LOGIN@yandex.ru';
  EPasswd.Text := 'PASSWORD';
  CBTLS.Checked := True;
  CBFullSSL.Checked := False;
  MGSMTP1.FromEmail := 'LOGIN@yandex.ru';
end;

procedure TMainForm.MGSMTP1ReadFilter(Sender: TObject; var Value: AnsiString);
begin
  MemoLog.Lines.Add('ReadFilter: ' + Value);
end;

procedure TMainForm.MGSMTP1Status(Sender: TObject; Reason: THookSocketReason;
  const Value: string);
begin
  if Value <> '' then
  case Reason of
    HR_ResolvingBegin: MemoLog.Lines.Add('Start resolving: ' + Value);
    HR_ResolvingEnd: MemoLog.Lines.Add('End resolving: ' + Value);
    HR_SocketCreate: MemoLog.Lines.Add('Socket created: ' + Value);
    HR_SocketClose: MemoLog.Lines.Add('Socket closed: ' + Value);
    HR_Bind: MemoLog.Lines.Add('Socket binded: ' + Value);
    HR_Connect: MemoLog.Lines.Add('Socket connected: ' + Value);
    HR_CanRead: MemoLog.Lines.Add('Read: ' + Value);
    HR_CanWrite: MemoLog.Lines.Add('Write: ' + Value);
    HR_Listen: MemoLog.Lines.Add('Listen: ' + Value);
    HR_Accept: MemoLog.Lines.Add('Accept: ' + Value);
    HR_ReadCount: MemoLog.Lines.Add('ReadCount: ' + Value);
    HR_WriteCount: MemoLog.Lines.Add('WriteCount: ' + Value);
    HR_Wait: MemoLog.Lines.Add('Wait: ' + Value);
    HR_Error: MemoLog.Lines.Add('Error: ' + Value);
  end;
end;

procedure TMainForm.ButtonSendClick(Sender: TObject);
{var
  MailToList: TStringList;}
begin
  MGSMTP1.Host := EHost.Text;
  MGSMTP1.Port := StrToInt(EPort.Text);
  MGSMTP1.Login := ELogin.Text;
  MGSMTP1.Password := EPasswd.Text;
  MGSMTP1.UseTLS := CBTLS.Checked;
  MGSMTP1.FullSSL := CBFullSSL.Checked;
  MGSMTP1.FromEmail := EFrom.Text;
  MGSMTP1.Recipients.Clear;
  MGSMTP1.Recipients.Text := ETo.Text;
  {MailToList := TStringList.Create;
  MailToList.Text := StringReplace(ETo.Text, ';', #13#10, [rfReplaceAll]);
  MGSMTP1.Recipients.Assign(MailToList);
  MailToList.Free;}
  MGSMTP1.AddText(MemoText.Text);
  if MGSMTP1.SendMessage('Test', False) then
    MemoLog.Lines.Add('Send done')
  else
    MemoLog.Lines.Add('Error sending');
end;

end.
