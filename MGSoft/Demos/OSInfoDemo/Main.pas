unit Main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, MGOSInfo;

type
  TMainForm = class(TForm)
    MemoVersion: TMemo;
    MGOSInfo1: TMGOSInfo;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormShow(Sender: TObject);
var
  Title: String;
begin
  Title := 'Information about the system';
  MemoVersion.Lines.Add(Title);
  MemoVersion.Lines.Add(StringOfChar('-', Length(Title)));
  MemoVersion.Lines.Add(MGOSInfo1.Display('Windows', MGOSInfo1.WindowsProductName));
  MemoVersion.Lines.Add(MGOSInfo1.Display('IsWOW64', MGOSInfo1.IsWindowsX64));
  MemoVersion.Lines.Add(MGOSInfo1.Display('Service Pack', MGOSInfo1.WindowsServicePack));
  MemoVersion.Lines.Add(MGOSInfo1.Display('Version builds', MGOSInfo1.WindowsBuildNumber));
  MemoVersion.Lines.Add(MGOSInfo1.Display('Product type', MGOSInfo1.WindowsProductTypeName));
  MemoVersion.Lines.Add(MGOSInfo1.Display('Product edition', MGOSInfo1.WindowsProductEdition));
  MemoVersion.Lines.Add(MGOSInfo1.Display('Internet Explorer version', MGOSInfo1.WindowsIEVersion));
  if MGOSInfo1.WindowsIEUpdateVersion <> '' then
    MemoVersion.Lines.Add(MGOSInfo1.Display('Internet Explorer updates version', MGOSInfo1.WindowsIEUpdateVersion));
end;

end.
