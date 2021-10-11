unit ChoixCouleurPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,Registry, WinSkinStore, WinSkinData,
  ComCtrls, ExtDlgs;

type
  TChoixCouleur = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    GroupBox1: TGroupBox;
    RadioGroupSons: TRadioGroup;
    RadioGroupVisible: TRadioGroup;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    GroupBox4: TGroupBox;
    Image5: TImage;
    GroupBox5: TGroupBox;
    StaticText3: TStaticText;
    Couleur: TComboBox;
    Panel1: TPanel;
    BitBtn1: TBitBtn;
    GroupBox6: TGroupBox;
    GroupBox7: TGroupBox;
    GroupBox10: TGroupBox;
    GroupBox11: TGroupBox;
    CheckBox4: TCheckBox;
    CheckBox5: TCheckBox;
    GroupBox12: TGroupBox;
    Absent: TCheckBox;
    Temps: TEdit;
    OpenTextFileDialog1: TOpenTextFileDialog;
    SpeedButton1: TSpeedButton;
    GroupBox8: TGroupBox;
    Label1: TLabel;
    Fichier: TEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure CouleurClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure SystemeCommande(var Msg: TMessage);
      message WM_SysCommand; // interception des messages SysCommand

     procedure ReadSkinfile( apath : string );

  public
    { Déclarations publiques }
  end;

var
  ChoixCouleur: TChoixCouleur;

implementation

uses UnitChatRL, Unit_MsgPerso;


{$R *.dfm}

procedure TChoixCouleur.FormCreate(Sender: TObject);
var
  Registre : TRegistry;
begin
  readskinfile(path);
  
  Registre:=TRegistry.Create;
  Registre.RootKey:=HKEY_LOCAL_MACHINE;

  Registre.OpenKey('\Software\IntraMSN\Couleur\',True);
  if Registre.ValueExists('Couleur') then
   Couleur.Text:=Registre.ReadString('Couleur');

  Registre.OpenKey('\Software\IntraMSN\Son\',True);
  if Registre.ValueExists('Son') then
    RadioGroupSons.ItemIndex := Registre.ReadInteger('Son');

  Registre.OpenKey('\Software\IntraMSN\Afficher\',True);
  if Registre.ValueExists('Afficher') then
    RadioGroupVisible.ItemIndex := Registre.ReadInteger('Afficher');

  Registre.OpenKey('\Software\IntraMSN\Image\',True);
  if Registre.ValueExists('Image') then
  begin
    Image5.Width := Registre.ReadInteger('Image');
    Image5.Height := Registre.ReadInteger('Image');
  end;

  Registre.OpenKey('\Software\IntraMSN\Transfert\',True);
  if Registre.ValueExists('Fichier') then
    Fichier.Text := Registre.ReadString('Fichier')
  else
    Fichier.Text := root;

  Registre.OpenKey('\Software\IntraMSN\Absent\',True);
  if Registre.ValueExists('Activer') then
    Absent.Checked := Registre.ReadBool('Activer');
  if Registre.ValueExists('Activer') then
    Temps.Text := Registre.ReadString('Temps');

  Registre.CloseKey;
  Registre.Free;
end;

procedure TChoixCouleur.BitBtn1Click(Sender: TObject);
var
  Registre : TRegistry;
begin
  Registre:=TRegistry.Create;
  Registre.RootKey:=HKEY_LOCAL_MACHINE;

  Registre.OpenKey('\Software\IntraMSN\Couleur\',True);
  Registre.WriteString('Couleur',  ChatRL.sd1.SkinFile);

  Registre.OpenKey('\Software\IntraMSN\Son\',True);
  Registre.WriteInteger('Son', RadioGroupSons.ItemIndex);

  Registre.OpenKey('\Software\IntraMSN\Afficher\',True);
  Registre.WriteInteger('Afficher', RadioGroupVisible.ItemIndex);

  Registre.OpenKey('\Software\IntraMSN\Image\',True);
  Registre.WriteInteger('Image',Image5.Width);
  ChatRL.ClientDataSet1IMAGE.DisplayWidth := Round(Image5.Width / 6);

  Registre.OpenKey('\Software\IntraMSN\Absent\',True);
  Registre.WriteBool('Activer',Absent.Checked);
  Registre.WriteString('Temps',Temps.Text);

  Registre.OpenKey('\Software\IntraMSN\Transfert\',True);
  Registre.WriteString('Fichier',Fichier.Text);

  Registre.CloseKey;
  Registre.Free;
  
  ChoixCouleur.Close;
end;

procedure TChoixCouleur.SpeedButton1Click(Sender: TObject);
begin
  if(OpenTextFileDialog1.Execute)Then
    Fichier.Text := OpenTextFileDialog1.FileName;
end;

procedure TChoixCouleur.SystemeCommande(var Msg: TMessage);
begin
  if Msg.wParam = sc_Close then ;
end;

procedure TChoixCouleur.Image1Click(Sender: TObject);
var
  i : integer;
begin
  Image5.Width := (Sender as TImage).Width;
  Image5.Height := (Sender as TImage).Height;
end;

procedure TChoixCouleur.CouleurClick(Sender: TObject);
begin
   ChatRL.sd1.SkinFile:=path+Couleur.Text;
   if not ChatRL.sd1.Active then ChatRL.sd1.Active:=true;
end;

procedure TChoixCouleur.ReadSkinfile( apath : string );
var
  sts: Integer ;
  SR: TSearchRec;
  list: Tstringlist;

  procedure AddFile;
  begin
    list.add(sr.name);
  end;

begin
  list:=Tstringlist.create;
  sts := FindFirst( apath + '*.skn' , faAnyFile , SR );
  if sts = 0 then begin
      if ( SR.Name <> '.' ) and ( SR.Name <> '..' ) then begin
          if pos('.', SR.Name) <> 0 then
            Addfile;
      end;
      while FindNext( SR ) = 0 do begin
          if ( SR.Name <> '.' ) and ( SR.Name <> '..' ) then begin
              if Pos('.', SR.Name) <> 0 then  Addfile;
          end;
      end;
  end ;
  FindClose( SR ) ;
  list.sort;
  Couleur.items.assign(list);
  list.free;
end;

end.

