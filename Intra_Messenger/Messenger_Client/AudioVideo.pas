unit AudioVideo;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,Registry, WinSkinStore, WinSkinData,
  AMixer, MMSystem, ComCtrls, dxGDIPlusClasses, Camera;

type
  TCAudioVideo = class(TForm)
    Mixer: TAudioMixer;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox2: TGroupBox;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    LabelStereo: TLabel;
    Image2: TImage;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    TrackBar: TTrackBar;
    CheckBox: TCheckBox;
    GroupBox3: TGroupBox;
    GroupBox4: TGroupBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Image1: TImage;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    TrackBar1: TTrackBar;
    CheckBox1: TCheckBox;
    GroupBox5: TGroupBox;
    GroupBox6: TGroupBox;
    Label5: TLabel;
    Image3: TImage;
    TrackBar2: TTrackBar;
    Camera1: TCamera;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    TrackBar3: TTrackBar;
    Label10: TLabel;
    Label11: TLabel;
    TrackBar4: TTrackBar;
    procedure FormCreate(Sender: TObject);
    procedure ComboBox3Change(Sender: TObject);
    procedure ComboBox2Change(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure MixerControlChange(Sender: TObject; MixerH, ID: Integer);
    procedure TrackBarChange(Sender: TObject);
    procedure CheckBoxClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure TrackBar2Change(Sender: TObject);
    procedure TabSheet2Show(Sender: TObject);
    procedure TabSheet1Show(Sender: TObject);
    procedure ComboBox6Change(Sender: TObject);
    procedure ComboBox4Change(Sender: TObject);
    procedure ComboBox5Change(Sender: TObject);
    procedure TrackBar3Change(Sender: TObject);
    procedure TrackBar4Change(Sender: TObject);
  private
    { Déclarations privées }
    Setting:Boolean;
  public
    { Déclarations publiques }
  end;

var
  CAudioVideo: TCAudioVideo;

implementation

uses UnitChatRL, Unit_MsgPerso;


{$R *.dfm}

procedure TCAudioVideo.FormCreate(Sender: TObject);
var A:Integer;
begin
  For A := 0 to Mixer.MixerCount - 1 do
    ComboBox3.Items.Add (Mixer.ProductName);
  If (ComboBox3.Items.Count > 0) then
    ComboBox3.ItemIndex := 0;
  ComboBox3Change (Sender);

  For A := 0 to Mixer.MixerCount - 1 do
    ComboBox6.Items.Add (Mixer.ProductName);
  If (ComboBox6.Items.Count > 0) then
    ComboBox6.ItemIndex := 0;
  ComboBox6Change (Sender);

end;

procedure TCAudioVideo.MixerControlChange(Sender: TObject; MixerH, ID: Integer);
begin
     ComboBox2Change(Self);
end;

procedure TCAudioVideo.TabSheet1Show(Sender: TObject);
begin
     if(Camera1.Actif)Then
      Camera1.Actif := False;
end;

procedure TCAudioVideo.TabSheet2Show(Sender: TObject);
begin
  if(not Camera1.Actif)Then
    Camera1.Actif := True;
end;

procedure TCAudioVideo.TrackBar2Change(Sender: TObject);
begin
Camera1.FramesPreview := TrackBar2.Position;
end;

procedure TCAudioVideo.TrackBar3Change(Sender: TObject);
begin
Camera1.FramesCaptura := TrackBar3.Position;
end;

procedure TCAudioVideo.TrackBar4Change(Sender: TObject);
begin
Camera1.Secondes:=TrackBar4.Position;
end;

procedure TCAudioVideo.TrackBarChange(Sender: TObject);
begin
   If (not Setting) then
  begin
    Setting:=True;
    Mixer.SetVolume (ComboBox1.ItemIndex,ComboBox2.ItemIndex-1,TrackBar.Position,TrackBar.Position,Integer(CheckBox.Checked));
    Setting:=False;
  end;
end;

procedure TCAudioVideo.BitBtn1Click(Sender: TObject);
begin
  Close;
end;

procedure TCAudioVideo.CheckBoxClick(Sender: TObject);
begin
      If not Setting then
  begin
    Setting:=True;
    Mixer.SetVolume (ComboBox1.ItemIndex,ComboBox2.ItemIndex-1,TrackBar.Position,TrackBar.Position,Integer(CheckBox.Checked));
    Setting:=False;
  end;
end;

procedure TCAudioVideo.ComboBox1Change(Sender: TObject);
var A:Integer;
begin
  ComboBox2.Items.Clear;
  For A:=0 to Mixer.Destinations[ComboBox1.ItemIndex].Connections.Count-1 do
    ComboBox2.Items.Add(Mixer.Destinations[ComboBox1.ItemIndex].Connections[A].Data.szName);
  If ComboBox2.Items.Count>0 then
  begin
    ComboBox2.ItemIndex:=0;
    ComboBox2Change (Self);
  end;
end;

procedure TCAudioVideo.ComboBox2Change(Sender: TObject);
var L,R,M:Integer;
    VD,MD:Boolean;
    Stereo:Boolean;
    IsSelect:Boolean;
begin
  Mixer.GetVolume (ComboBox1.ItemIndex,ComboBox2.ItemIndex-1,L,R,M,Stereo,VD,MD,IsSelect);
  Setting:=True;
  TrackBar.Visible:=not VD;
  Label1.Visible:=not VD;
  Label3.Visible:=VD;
  If TrackBar.Visible then
    TrackBar.Position:=L;
  CheckBox.Visible:=not MD;
  Label2.Visible:=not MD;
  Label4.Visible:=MD;
  If CheckBox.Visible then
    CheckBox.Checked:=M<>0;
  If (Stereo) then
    LabelStereo.Caption := '- stereo -'
  else
    LabelStereo.Caption := '- mono -';
  Setting:=False;
end;

procedure TCAudioVideo.ComboBox3Change(Sender: TObject);
var A:Integer;
begin
  If (ComboBox3.ItemIndex >= 0) AND (ComboBox3.ItemIndex < Mixer.MixerCount) then
    Mixer.MixerId := ComboBox3.ItemIndex;
  ComboBox1.Items.Clear;
  If Mixer.MixerCount>0 then
  begin
    For A:=0 to Mixer.Destinations.Count-2 do
      ComboBox1.Items.Add (Mixer.Destinations[A].Data.szName);
    If ComboBox1.Items.Count>0 then
    begin
      ComboBox1.ItemIndex:=0;
      ComboBox1Change (Self);
    end;
  end
  else
  begin
    ComboBox1.OnChange:=nil;
    ComboBox2.OnChange:=nil;
    TrackBar.OnChange:=nil;
    CheckBox.OnClick:=nil;
    MessageDlg ('No mixer present in the system !',mtError,[mbOK],0);
  end;
  Setting:=False;
end;

procedure TCAudioVideo.ComboBox4Change(Sender: TObject);
var A:Integer;
begin
  ComboBox5.Items.Clear;
  For A:=0 to Mixer.Destinations[ComboBox4.ItemIndex + 1].Connections.Count-1 do
    ComboBox5.Items.Add(Mixer.Destinations[ComboBox4.ItemIndex + 1].Connections[A].Data.szName);
  If ComboBox5.Items.Count>0 then
  begin
    ComboBox5.ItemIndex:=0;
    ComboBox5Change (Self);
  end;
end;

procedure TCAudioVideo.ComboBox5Change(Sender: TObject);
var L,R,M:Integer;
    VD,MD:Boolean;
    Stereo:Boolean;
    IsSelect:Boolean;
begin
  Mixer.GetVolume (ComboBox4.ItemIndex,ComboBox5.ItemIndex-1,L,R,M,Stereo,VD,MD,IsSelect);
  Setting:=True;
  TrackBar1.Visible:=not VD;
  Label6.Visible:=not VD;
  Label8.Visible:=VD;
  If TrackBar1.Visible then
    TrackBar1.Position:=L;
  CheckBox1.Visible:=not MD;
  Label7.Visible:=not MD;
  Label9.Visible:=MD;
  If CheckBox1.Visible then
    CheckBox1.Checked:=M<>0;
  Setting:=False;
end;

procedure TCAudioVideo.ComboBox6Change(Sender: TObject);
var A:Integer;
begin
  If (ComboBox6.ItemIndex >= 0) AND (ComboBox6.ItemIndex < Mixer.MixerCount) then
    Mixer.MixerId := ComboBox6.ItemIndex;
  ComboBox4.Items.Clear;
  If Mixer.MixerCount>0 then
  begin
    For A:=1 to Mixer.Destinations.Count-1 do
      ComboBox4.Items.Add (Mixer.Destinations[A].Data.szName);
    If ComboBox4.Items.Count>0 then
    begin
      ComboBox4.ItemIndex:=0;
      ComboBox4Change (Self);
    end;
  end
  else
  begin
    ComboBox4.OnChange:=nil;
    ComboBox5.OnChange:=nil;
    TrackBar.OnChange:=nil;
    CheckBox.OnClick:=nil;
    MessageDlg ('No mixer present in the system !',mtError,[mbOK],0);
  end;
  Setting:=False;
end;

end.

