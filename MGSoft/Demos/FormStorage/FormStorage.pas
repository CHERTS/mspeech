unit FormStorage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, MGPlacement;

type
  TMainForm = class(TForm)
    MGFormStorage1: TMGFormStorage;
    TrackBar1: TTrackBar;
    Panel1: TPanel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

end.
