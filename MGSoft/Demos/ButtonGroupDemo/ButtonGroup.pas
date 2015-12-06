{ ################################################################################## }
{ #                                                                                # }
{ #  MGSoft MGButtonGroup Demo v1.0.0 - Демонстрация работы MGButtonGroup          # }
{ #                                                                                # }
{ #  License: GPLv3                                                                # }
{ #                                                                                # }
{ #  MGSoft MGButtonGroup Demo                                                     # }
{ #                                                                                # }
{ #  Author: Mikhail Grigorev (icq: 161867489, email: sleuthhound@gmail.com)       # }
{ #                                                                                # }
{ ################################################################################## }

unit ButtonGroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ImgList, MGButtonGroup, ButtonGroup;

type
  TMainForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    Label5: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    ImageList1: TImageList;
    MGDemo: TMGButtonGroup;
    procedure Button1Click(Sender: TObject);
    procedure IMDemoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MGDemoKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.FormCreate(Sender: TObject);
begin
  PageControl1.Pages[0].TabVisible := False;
  PageControl1.Pages[1].TabVisible := False;
  PageControl1.Pages[2].TabVisible := False;
  PageControl1.Pages[3].TabVisible := False;
  PageControl1.Pages[4].TabVisible := False;
  PageControl1.ActivePage := TabSheet1;
  MGDemo.ItemIndex := 0;
end;

procedure TMainForm.IMDemoClick(Sender: TObject);
begin
  PageControl1.ActivePageIndex := MGDemo.ItemIndex;
end;

procedure TMainForm.MGDemoKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  PageControl1.ActivePageIndex := MGDemo.ItemIndex;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
