{ ############################################################################ }
{ #                                                                          # }
{ #  IMButtonGroup Demo                                                      # }
{ #                                                                          # }
{ #  Base on SVButtonGroup                                                   # }
{ #  Copyright (C) 2011 "Linas Naginionis"                                   # }
{ #  http://code.google.com/p/sv-utils/                                      # }
{ #  Linas Naginionis lnaginionis@gmail.com                                  # }
{ #                                                                          # }
{ #  License: GPLv3                                                          # }
{ #                                                                          # }
{ #  Author: Grigorev Michael (icq: 161867489, email: sleuthhound@gmail.com) # }
{ #                                                                          # }
{ #  Доработки по сравнению с SVButtonGroup:                                 # }
{ #  + Убрана поддержка html тегов в имени кнопок                            # }
{ #  + Добавлены свойства BorderButtonColor, BorderButtonDownColor и         # }
{ #    ButtonBorder для реализации рамки вокруг кнопок.                      # } 
{ #                                                                          # }
{ ############################################################################ }

unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ImgList, uIMButtonGroup, ButtonGroup;

type
  TForm1 = class(TForm)
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
    IMDemo: TIMButtonGroup;
    procedure Button1Click(Sender: TObject);
    procedure IMDemoClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  PageControl1.Pages[0].TabVisible := False;
  PageControl1.Pages[1].TabVisible := False;
  PageControl1.Pages[2].TabVisible := False;
  PageControl1.Pages[3].TabVisible := False;
  PageControl1.Pages[4].TabVisible := False;
  PageControl1.ActivePage := TabSheet1;
  IMDemo.ItemIndex := 0;
end;

procedure TForm1.IMDemoClick(Sender: TObject);
begin
  PageControl1.ActivePageIndex := IMDemo.ItemIndex;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Close;
end;

end.
