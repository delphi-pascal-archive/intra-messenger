{Cette unité a pour but de pouvoir faire quelques reglages sur le chat.
Je crois me souvenir de quelques problemes mais ca change rien au fonctionnement du chat  :) }

unit ChoixCouleurPanel;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls;

type
  TChoixCouleur = class(TForm)
    GroupBox1: TGroupBox;
    BitBtn1: TBitBtn;
    RadioGroupSons: TRadioGroup;
    RadioGroupVisible: TRadioGroup;
    GroupBoxCouleur: TGroupBox;
    ColorDialog1: TColorDialog;
    Panel1: TPanel;
    StaticText1: TStaticText;
    Button1: TButton;
    StaticText2: TStaticText;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private
    { Déclarations privées }
    procedure SystemeCommande(var Msg : TMessage);
    message WM_SysCommand; // interception des messages SysCommand

  public
    { Déclarations publiques }
  end;

var
  ChoixCouleur: TChoixCouleur;

implementation

uses UnitChatRL;


{$R *.dfm}

procedure TChoixCouleur.FormCreate(Sender: TObject);
var
   Style : LongInt; // pour enlever la barre de titres
begin
   {les 4 lignes suivantes permettent de rendre invisible la barre de titres}
   Style := GetWindowLong(Handle,GWL_STYLE); // Mémorise le style courant
   Style := Style and not WS_CAPTION;     // Retire au Style courant l'affichage de la barre de titre
   SetWindowLong(Handle,GWL_STYLE,Style);   // Effectue la modification
   SetWindowPos(Handle,0,0,0,0,0,SWP_FRAMECHANGED or SWP_NOMOVE or SWP_NOSIZE or SWP_NOZORDER);  // Mise à jour de la fenêtre

end;

procedure TChoixCouleur.BitBtn1Click(Sender: TObject);
var
  n: Integer;  // Sert dans l'activation de CtrlAltSupp et AltTab
begin
     SystemParametersInfo(SPI_SCREENSAVERRUNNING, 0, @n, 0); // Permet à la fermeture de réactiver CtrlAltSupp et AltTab
     ClipCursor(nil); // Annule la limitation du déplacement de la souris.

     Couleur := ChoixCouleur.Panel1.Color;
     ChatRL.Colorier;
     ChoixCouleur.Close;
end;

procedure TChoixCouleur.SystemeCommande(var Msg : TMessage);
begin
    //inherited; // instruction pour que les messages soient traités normalement
    if Msg.wParam = sc_Close then ; // Réponse au Alt-F4
end;




procedure TChoixCouleur.FormShow(Sender: TObject);
var
   n: Integer;  // Sert dans la déactivation de CtrlAltSupp et AltTab
   Rect: TRect;   // Zone de limitation pour la souris
begin
   application.ProcessMessages;
   SystemParametersInfo(SPI_SCREENSAVERRUNNING, Integer(TRUE), @n, 0);  // Désactiver CtrlAltSupp et AltTab

   { Convertie les coordonnées de la fiche avec celles de l'écran }
   Rect.TopLeft:= ClientToScreen(ClientRect.TopLeft);
   Rect.BottomRight:= ClientToScreen(ClientRect.BottomRight);
   ClipCursor(@Rect); // Limite le déplacement de la souris à la zone Client de la fiche.

   ChoixCouleur.Panel1.Color := Couleur;
   ChoixCouleur.GroupBox1.Color := Couleur;
   ChoixCouleur.RadioGroupSons.Color := Couleur;
   ChoixCouleur.RadioGroupVisible.Color := Couleur;
   ChoixCouleur.GroupBoxCouleur.Color := Couleur;

end;

procedure TChoixCouleur.Button1Click(Sender: TObject);
begin
   Panel1.Color := clBtnFace;
end;

procedure TChoixCouleur.Panel1Click(Sender: TObject);
var
  n: Integer;  // Sert dans l'activation de CtrlAltSupp et AltTab
  Rect: TRect;   // Zone de limitation pour la souris
begin
  SystemParametersInfo(SPI_SCREENSAVERRUNNING, 0, @n, 0); // Permet à la fermeture de réactiver CtrlAltSupp et AltTab
  ClipCursor(nil); // Annule la limitation du déplacement de la souris.

  If (ColorDialog1.Execute=True) Then
  Begin
     Panel1.Color:=ColorDialog1.Color;
     Repaint;
  End;

  SystemParametersInfo(SPI_SCREENSAVERRUNNING, Integer(TRUE), @n, 0);  // Désactiver CtrlAltSupp et AltTab
  { Convertie les coordonnées de la fiche avec celles de l'écran }
  Rect.TopLeft:= ClientToScreen(ClientRect.TopLeft);
  Rect.BottomRight:= ClientToScreen(ClientRect.BottomRight);
  ClipCursor(@Rect); // Limite le déplacement de la souris à la zone Client de la fiche.

end;

end.
