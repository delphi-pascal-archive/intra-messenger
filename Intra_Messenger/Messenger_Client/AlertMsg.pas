unit AlertMsg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, Buttons, ImgList;

type
  TAlertMsgF = class(TForm)
    ExecutionTimer: TTimer;
    IconImg: TImage;
    IconsList: TImageList;
    FondImg: TImage;
    TitleLbl: TLabel;
    TextLbl: TLabel;
    procedure ExecutionTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    OGhigh: integer; // Taille d'origine de la form
    WaitBeforeDownCounter: integer;
    WaitBeforeDownTime: integer;
    AlertWindowState : byte; // 0=mont�e ; 1=stop ; 2=descente ; 3=inactivation - voir "const"
    IsRunning: boolean;
  end;

procedure AlertMsgBox(ATitle, AText: string; AIcon:integer=0; ABeep:boolean=false; WaitBeforeDown:integer=1000; StepTime:integer=10; OnTextClick:TNotifyEvent=nil);

var
 AlertMsgF: TAlertMsgF;

const // DEFINITION DES CONSTANTES FACILITANT L'UTILISATION DE LA PROCEDURE D'APPEL
 ICON_NONE=0; ICON_INFO=1; ICON_QUESTION1=2; ICON_QUESTION2=3; ICON_WARNING1=4;
 ICON_WARNING2=5; ICON_QUIT=6; ICON_STOP=7; ICON_GO=8; ICON_SECURE=9;
 ICON_VALIDATE=10; ICON_SEARCH=11; ICON_SENDMAIL=12; ICON_NEWMAIL=13; ICON_USER=14;
 // CONSTANTES PERMETTANT UNE MEILLEURE COMPREHENSION DU CODE
 WS_UP=0; WS_STOP=1; WS_DOWN=2; WS_DISABLED=3;

implementation

{$R *.dfm}

// INITIALISATION DES PARAMETRES
procedure TAlertMsgF.FormCreate(Sender: TObject);
var Rect: TRect;
begin
 DoubleBuffered := true;                                 // On �vite le scintillement
 OGhigh := ClientHeight;                                 // On m�morise la hauteur initiale de la form
 FormStyle := fsStayOnTop;                               // Form au dessus de toutes les autres
 Left:=Screen.Width-ClientWidth;                         // La form se tiendra pile � droite de l'�cran
 SystemParametersInfo(SPI_GETWORKAREA, 0, @Rect, 0);     // On r�cup�re la hauteur de la barre des t�ches
 Top := Screen.Height - (Screen.Height - Rect.Bottom)-1; // On place le haut de la form � la limite de la barre des t�ches
 ClientHeight := 1;                                      // Le bas de la form restera confondu avec le haut : on ne verra qu'une ligne au d�but
 IsRunning := false;                                     // Drapeau d'ex�cution
end;


// APPEL DE LA MESSAGEBOX
procedure AlertMsgBox(ATitle, AText: string; AIcon:integer=0; ABeep:boolean=false; WaitBeforeDown:integer=1000; StepTime:integer=10; OnTextClick:TNotifyEvent=nil);
begin
 with AlertMsgF do begin // On travaille avec la form d'alerte


   // ON EMPECHE DEUX EXECUTIONS SIMULTANEES
   // si une alerte est d�j� en cours d'affichage, on diff�re la suivante
   while IsRunning do Application.ProcessMessages;
   IsRunning := true; // Lev�e du drapeau


   // CONFIGURATION DE LA FENETRE D'ALERTE  ( TEXTE ET ICONES )
   Caption := ATitle; // Titre
   TitleLbl.Caption := ATitle;
   TextLbl.Caption := AText; // Texte
   if AIcon = 0 then begin // Mise en place de l'ic�ne choisie
    IconImg.Picture := nil; // Aucune ic�ne
    TitleLbl.Left := 3; TitleLbl.Width := 173; // On �tend le titre sur toute la largeur
   end else begin
    IconImg.Picture := nil; // On efface d'abord l'ic�ne actuelle (sinon risque de superposition)
    IconsList.GetBitmap(AIcon-1,IconImg.Picture.Bitmap); // Pour afficher la nouvelle
    TitleLbl.Left := 21; TitleLbl.Width := 155; // On ajuste la largeur du titre
   end;


   // CONFIGURATION DE LA PROCEDURE APPELEE LORS D'UN CLIC EVENTUEL SUR LE MESSAGE
   if Assigned(OnTextClick) then begin // Si une proc�dure est d�sign�e...
     TextLbl.Cursor := crHandPoint; // On change le curseur
     TextLbl.OnClick := OnTextClick; // On assigne la proc�dure � l'�v�nement du clic
   end else begin // Sinon...
     TextLbl.Cursor := crDefault; // On r�tablit le curseur
     TextLbl.OnClick := nil; // On ne donne pas suite � l'�v�nement de clic
   end;


   // AFFICHAGE DE L'ALERTE  ( PARAMETRAGE ET LANCEMENT DU TIMER )
   WaitBeforeDownTime := WaitBeforeDown div StepTime; // D�finition du nombre de cycles d'attente n�cessaires
   ExecutionTimer.Interval := StepTime;
   AlertWindowState := WS_UP; // D�finition du statut de la fen�tre
   Show; // Affichage
   if ABeep then Beep; // Beep si demand�
   ExecutionTimer.Enabled := true; // Activation du Timer
 end;
end;


procedure TAlertMsgF.ExecutionTimerTimer(Sender: TObject);
begin
// LA PROCEDURE EST IMPLEMENTEE DANS UN TIMER POUR EVITER QUE L'APPLICATION NE FREEZE

 if AlertWindowState = WS_DISABLED then begin // Si aucune op�ration n'est demand�e, on quitte la proc�dure et on d�sactive le timer
  ExecutionTimer.Enabled := false; exit;
  // Test de s�curit� pr�sent au cas o� le d�veloppeur active manuellement le timer dans le code d'une autre form,
  // ce qui entra�nerait un mauvais param�trage initial et une consommation inutile de ressources d�s aux
  // appels de Application.ProcessMessages pr�sents dans le timer


 end else if AlertWindowState = WS_UP then begin // PHASE DE MONTEE
       ClientHeight := ClientHeight + 1;
       Top := Top - 1;
       if ClientHeight=OGhigh then begin // Une fois en haut, on change le statut
        WaitBeforeDownCounter := 0;
        AlertWindowState:=WS_STOP;
       end;


 end else if AlertWindowState = WS_STOP then begin // PHASE D'ARRET
      inc(WaitBeforeDownCounter);
      if WaitBeforeDownCounter = WaitBeforeDownTime then begin // Au bout du temps d'attente, on rechange le statut
        WaitBeforeDownCounter := 0;
        AlertWindowState:=WS_DOWN;
      end;


 end else if AlertWindowState = WS_DOWN then begin // PHASE DE DESCENTE
       ClientHeight := ClientHeight - 1;
       Top := Top + 1;
       if ClientHeight=1 then begin // Une fois en bas, on arr�te
        AlertWindowState:=WS_DISABLED;
        ExecutionTimer.Enabled := false;
        Visible := false;
        IsRunning := false; // Changement de l'�tat du drapeau pour permettre une autre ex�cution
       end;
 end;



 FormStyle := fsStayOnTop;
 Application.ProcessMessages;
end;

end.
