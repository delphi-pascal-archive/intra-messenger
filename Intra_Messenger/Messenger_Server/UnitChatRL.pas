unit UnitChatRL;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls,WinSock, Buttons, ScktComp, ExtCtrls, Grids,
  ValEdit, Menus, Math,ShellAPI;
  
const
    WM_CAllBack = WM_USER;

type
  TChatRL = class(TForm)
    PageControl: TPageControl;
    TabSheetServeur: TTabSheet;
    GroupBox1: TGroupBox;
    LabelIP: TLabel;
    ServerSocket: TServerSocket;
    TimerInformationsChateur: TTimer;
    BitBtnLancerS: TBitBtn;
    TimerNombresClientsActuels: TTimer;


    procedure TabSheetServeurShow(Sender: TObject);
    function TrouverIP(ordinateur : string) : string;
    function NomPcActuel : string;
    function MessageInfo : string;
    procedure FormCreate(Sender: TObject);
    procedure ServerSocketAccept(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtnLancerSClick(Sender: TObject);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure AnalysePremiereInformation(MessageRecu : string);
    procedure AnalyseDerniereInformation(MessageRecu : string);
    procedure TimerInformationsChateurTimer(Sender: TObject);
    procedure NomClientParti;
    procedure PageControlChanging(Sender: TObject;
      var AllowChange: Boolean);

    procedure LabeledEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure Fermer1Click(Sender: TObject);
    procedure PasLeDroitDeSeConnecter(Login : string; Ordi : string; iden : integer);
    procedure VientDeSeDeconnecterVolontairement(MessageRecu : string);
    procedure VientDeSeDeconnecterCarVire(MessageRecu : string);
    procedure TropDeMondeSurLeServeur(MessageRecu : string);
    procedure ReponseDeMessageStatut(MessageRecu: string; MessageEnvoi: string);
    procedure ReponseDeMessagePrive(MessageRecu : string; MessageEnvoi : string);
    procedure AnalyseMessageRecuParServeur(Msg : String);
    procedure ServerSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);


  private
  public
  protected
        IsServer: Boolean;
  end;

type
    TStructureListeConnecte = record
         LoginConnecte : string[30];
         NomOrdinateur : string[30];
         Iden : integer;
         img : string;
    end;

var
  ChatRL: TChatRL;
  EditPortServeur : string;
  StructureOrdinateur,StructureOrdinateur002 :array[1..52] of TStructureListeConnecte;
  ComboBoxNombresClients,NumeroArriveConnexion,NombresMaximumClients,NombreSecret : integer;
  ServeurActif,ClientConnecter : boolean;
  Present: TDateTime;
  Hour, Min, Sec,MSec: Word;
  ChatHauteurDeDebut,ChatLargeurDeDebut,PageHauteurDebut,PageLargeurDebut : integer;
  TrayIcon : TNotifyIconData;
  blah : HICON;
  mvt : Integer; 

function UserName():string;


implementation

{$R *.dfm}

function QuelHeureEstIl : string;
begin
   Present:= Now;
   DecodeTime(Present, Hour, Min, Sec,MSec);
   result := '['+IntToStr(Hour)+':'+IntToStr(Min)+':'+IntToStr(Sec)+']';
end;
function droite(substr: string; s: string): string;
begin
  if pos(substr,s)=0 then result:='' else
    result:=copy(s, pos(substr, s)+length(substr), length(s)-pos(substr, s)+length(substr));
end;
function gauche(substr: string; s: string): string;
begin
  result:=copy(s, 1, pos(substr, s)-1);
end;
function TChatRL.TrouverIP(ordinateur : string) : string;
var
   WSAData : TWSAData;
   Name,Address : String;
   Phe : PHostEnt;
begin
    WSAStartup(2,WSAData);
    SetLength(Name,255);
    Phe := GetHostByName(PChar(ordinateur));
    with Phe^ do
    Address := Format ('%d.%d.%d.%d' , [Byte(h_addr^[0]),Byte(h_addr^[1]),
                                        Byte(h_addr^[2]),Byte(h_addr^[3])]);
    WSACleanup;
    TrouverIP := Address;
end;

function TChatRL.NomPcActuel : string;
var
  Buffer : array[0..255] of char;
  BufferSize : DWORD;
begin
  BufferSize := sizeOf(Buffer);
  GetComputerName(@buffer, BufferSize);
  result := buffer;
end;

procedure TChatRL.TabSheetServeurShow(Sender: TObject);
begin
        LabelIP.Caption := TrouverIP(NomPcActuel);
        GroupBox1.Caption := 'Caractéristiques du Serveur : '+ NomPcActuel;
        ComboBoxNombresClients := 999;
end;
procedure TChatRL.FormCreate(Sender: TObject);
var
   SysMenu: hMenu;
begin
  SysMenu := GetSystemMenu(Handle, False);
  ModifyMenu(SysMenu, sc_Close, mf_ByCommand, sc_Close, '&Quitter le Chat de Scarabee !!!'#9'Alt+F4');
  SysMenu := GetSystemMenu(application.handle,false);
  ModifyMenu(SysMenu, sc_Close, mf_ByCommand, sc_Close, '&Quitter le Chat de Scarabee !!!'#9'Alt+F4');


   
   Randomize;
   NombreSecret := RandomRange(1000,9999);

  ChatRL.Left := screen.Width - ChatRL.Width ;
  ChatRL.top := screen.height - ChatRL.height-30 ;

  blah := application.Icon.Handle;
  Trayicon.cbSize := SizeOf(TNotifyIconData);
  Trayicon.Wnd := handle;
  Trayicon.szTip := 'eSMessenger';
  Trayicon.uID := 1;
  TrayIcon.hIcon := blah;
  TrayIcon.uCallbackMessage := WM_CAllBack;
  Trayicon.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
  Shell_NotifyIcon(NIM_ADD,@trayicon);

  ChatRL.Visible := true;

  ChatRL.Paint;

  EditPortServeur := '2879';

end;
function UserName():string;
const
  cnMaxUserNameLen = 254;
var
 UserName2 : string;
 nSize : DWord;
 begin
 nSize := cnMaxUserNameLen - 1;
 SetLength(UserName2, cnMaxUserNameLen);

 GetUserName(Pchar(UserName2), nSize);

 SetLength(UserName2, nSize -1);

 result := UserName2;
 end;
procedure TChatRL.ServerSocketAccept(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  IsServer := True;
end;
procedure TChatRL.ServerSocketClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
     inc(NumeroArriveConnexion);
     TimerInformationsChateur.Enabled := TRUE;
end;
procedure TChatRL.FormClose(Sender: TObject; var Action: TCloseAction);
begin
   Fermer1Click(ChatRL);
end;
procedure TChatRL.BitBtnLancerSClick(Sender: TObject);
var
  i : integer;
begin
   if  (CompareStr('Lancer le Serveur',BitBtnLancerS.Caption)=0)  then
   begin
      if (EditPortServeur <> '') and ((strtoint(EditPortServeur)) > 0) then
      begin
      try
        NombresMaximumClients := ComboBoxNombresClients;
        ServerSocket.Port := strtoint(EditPortServeur);
        ServerSocket.Active := True;
        BitBtnLancerS.Caption := 'Arrêter le Serveur';
        ServeurActif := TRUE;
        NombresMaximumClients := ComboBoxNombresClients;
      except on ESocketError do
      begin
         MessageDlg('Vous ne pouvez pas lancer 2 serveurs sur un même ordinateur.', mtInformation, [mbOK], 0);
         BitBtnLancerS.Caption := 'Lancer le Serveur';
          TimerInformationsChateur.Enabled := FALSE;
          TimerInformationsChateur.Interval := 3000;
          fillchar(StructureOrdinateur,sizeof(StructureOrdinateur),0);
          fillchar(StructureOrdinateur002,sizeof(StructureOrdinateur002),0);
          NumeroArriveConnexion :=0;
          ServerSocket.Active := FALSE;
          ServeurActif := FALSE;
      end;
      end;
      end;
   end
   else if (CompareStr(BitBtnLancerS.Caption,'Arrêter le Serveur') =0) then
        begin
          for i:=0 to NumeroArriveConnexion-1 do
          begin
             ServerSocket.Socket.Connections[i].SendText(#13+'×»ûíç');  // envoie vers le client
          end;
          BitBtnLancerS.Caption := 'Lancer le Serveur';
          TimerInformationsChateur.Enabled := FALSE;
          TimerInformationsChateur.Interval := 3000;
          fillchar(StructureOrdinateur,sizeof(StructureOrdinateur),0);
          fillchar(StructureOrdinateur002,sizeof(StructureOrdinateur002),0);
          NumeroArriveConnexion :=0;
          ServerSocket.Active := FALSE;
          ServeurActif := FALSE;
        end;

end;
procedure TChatRL.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
      dec(NumeroArriveConnexion);
      if NumeroArriveConnexion = 0 then
      begin
        TimerInformationsChateur.Enabled := FALSE;
        TimerInformationsChateur.Interval := 3000;
      end;
end;

procedure TChatRL.ServerSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
var Rapport: string;
begin
  case ErrorEvent of
    eeGeneral: Rapport := 'Erreur inattendu ' + Socket.RemoteAddress;
    eeSend: Rapport := 'Erreur d''écriture sur la connexion socket' + Socket.RemoteAddress;
    eeReceive: Rapport := 'Erreur de lecture sur la connexion socket' + Socket.RemoteAddress;
    eeConnect: Rapport := 'Une demande de connexion déjà acceptée n''a pas pu être achevée' + Socket.RemoteAddress;
    eeDisconnect: Rapport := 'Erreur de fermeture d''une connexion' + Socket.RemoteAddress;
    eeAccept: Rapport := 'Erreur d''acceptation d''une demande de connexion cliente' + Socket.RemoteAddress;
  else
  end;
  ErrorCode := 0;
end;

procedure TChatRL.ServerSocketClientRead(Sender: TObject;Socket: TCustomWinSocket);
var
    TEMPO : string;
begin
  Application.ProcessMessages;
  TEMPO := socket.ReceiveText;

  while (pos(#13,TEMPO) <> 0) do
  begin
     AnalyseMessageRecuParServeur(gauche(#13,TEMPO));
     TEMPO := droite(#13,TEMPO);
  end;
  AnalyseMessageRecuParServeur(TEMPO);
end;       

procedure TChatRL.AnalyseMessageRecuParServeur(Msg : String);
var
    MessageRecuServeur, MessagePrivePourLesClient: string;
begin
     MessageRecuServeur := Msg;
     if copy(MessageRecuServeur,1,1) = 'µ' then
     begin
          if NombresMaximumClients+1 > ServerSocket.Socket.ActiveConnections then
          begin
            MessageRecuServeur := Gauche('÷',MessageRecuServeur);
            AnalysePremiereInformation(copy(MessageRecuServeur,2,length(MessageRecuServeur)-1));
          end
          else
          begin
              MessageRecuServeur := Gauche('÷',MessageRecuServeur);
              TropDeMondeSurLeServeur(copy(MessageRecuServeur,2,length(MessageRecuServeur)-1));
          end;
     end;
     if Comparestr(copy(MessageRecuServeur,1,5),'@DECO') = 0 then
     begin
              MessageRecuServeur := Gauche('Ê',MessageRecuServeur);
              MessageRecuServeur := Droite('@DECO',MessageRecuServeur);
              AnalyseDerniereInformation(MessageRecuServeur);
              NomClientParti;
              VientDeSeDeconnecterVolontairement(MessageRecuServeur);
     end;
     if Comparestr(copy(MessageRecuServeur, 1, 8), '#STATUT#') = 0 then
  begin
    MessagePrivePourLesClient := MessageRecuServeur;
    MessageRecuServeur := Gauche('#FIN#', MessageRecuServeur);
    MessageRecuServeur := Droite('#STATUT#', MessageRecuServeur);
    ReponseDeMessageSTATUT(MessageRecuServeur, MessagePrivePourLesClient);
  end;

     if Comparestr(copy(MessageRecuServeur,1,8),'MsgPrive')=0 then
     begin
         MessagePrivePourLesClient := MessageRecuServeur;
         MessageRecuServeur := Gauche('#FIN#',MessageRecuServeur);
         MessageRecuServeur := Droite('MsgPrive#DE#',MessageRecuServeur);
         ReponseDeMessagePrive(MessageRecuServeur,MessagePrivePourLesClient);
     end;

     if Comparestr(copy(MessageRecuServeur,1,12),'MsgTransfert')=0 then
     begin
         MessagePrivePourLesClient := MessageRecuServeur;
         MessageRecuServeur := Gauche('#FIN#',MessageRecuServeur);
         MessageRecuServeur := Droite('MsgTransfert#DE#',MessageRecuServeur);
         ReponseDeMessagePrive(MessageRecuServeur,MessagePrivePourLesClient);
     end;

     if Comparestr(copy(MessageRecuServeur,1,9),'MsgBouger')=0 then
     begin
         MessagePrivePourLesClient := MessageRecuServeur;
         MessageRecuServeur := Gauche('#FIN#',MessageRecuServeur);
         MessageRecuServeur := Droite('MsgBouger#DE#',MessageRecuServeur);
         ReponseDeMessagePrive(MessageRecuServeur,MessagePrivePourLesClient);
     end;
end;
procedure TChatRL.ReponseDeMessageStatut(MessageRecu: string; MessageEnvoi: string);
var
  LoginEnvoi: string;
  i: integer;
begin
  LoginEnvoi := Droite('#DE#', MessageRecu);
  MessageRecu := Gauche('#DE#', MessageRecu);

  for i := 0 to NumeroArriveConnexion - 1 do
  begin
    ServerSocket.Socket.Connections[i].SendText(#13 + MessageEnvoi);
  end;
end;
procedure TChatRL.ReponseDeMessagePrive(MessageRecu : string; MessageEnvoi : string);
var
   LoginEnvoi, LoginRecoi, MessageTexte : string;
   i : integer;
begin
    LoginEnvoi := Gauche('#POUR#',MessageRecu);
    MessageRecu := Droite('#POUR#',MessageRecu);
    LoginRecoi := Gauche('#CORPS#',MessageRecu);
    MessageTexte := Droite('#CORPS#',MessageRecu);

    for i:=0 to NumeroArriveConnexion-1 do
    begin
      ServerSocket.Socket.Connections[i].SendText(#13+MessageEnvoi);
    end;

end;
procedure TChatRL.TropDeMondeSurLeServeur(MessageRecu : string);
var
   i,iden : integer;
   Login,NomOrdi,MessageInfoDepart : string;
begin
   //EditLogin.Text + 'µ' + NomPcActuel+'«/\»'+inttostr(NombreSecret)
   Application.ProcessMessages;
   Login := Gauche('µ',MessageRecu);
   MessageRecu := Droite('µ',MessageRecu);
   NomOrdi := Gauche('«/\»',MessageRecu);
   iden := strtoint(Droite('«/\»',MessageRecu));

   MessageInfoDepart := 'TuEsViré°£°'+Login+'µ'+NomOrdi+'«/\»'+inttostr(iden)+'003';

   for i:=0 to NumeroArriveConnexion-1 do
   begin
      ServerSocket.Socket.Connections[i].SendText(#13+MessageInfoDepart);
   end;
end;

procedure TChatRL.VientDeSeDeconnecterVolontairement(MessageRecu : string);
var
   Login,NomOrdi : string;
   m : integer;
begin
   Application.ProcessMessages;
   Login := Gauche('µ',MessageRecu);
   MessageRecu := Droite('µ',MessageRecu);
   NomOrdi := Gauche('«/\»',MessageRecu);

   for m:=0 to NumeroArriveConnexion-1 do
   begin
       ServerSocket.Socket.Connections[m].SendText(#13+'„²´Ù¿'+'“”•œ'+'Serveur'+' >>  '+Login+' ('+NomOrdi+')'+' vient de se déconnecter...'+'°Ù#Æ]');
   end;
end;

procedure TChatRL.VientDeSeDeconnecterCarVire(MessageRecu : string);
var
   m : integer;
   Login,NomOrdi : string;
begin
   //EditLogin.Text + 'µ' + NomPcActuel+'«/\»'+inttostr(NombreSecret)
   Application.ProcessMessages;
   Login := Gauche('µ',MessageRecu);
   MessageRecu := Droite('µ',MessageRecu);
   NomOrdi := Gauche('«/\»',MessageRecu);

   for m:=0 to NumeroArriveConnexion-1 do
   begin
       ServerSocket.Socket.Connections[m].SendText(#13+'„²´Ù¿'+'“”•œ'+'Serveur'+' >>  '+Login+' ('+NomOrdi+')'+' a été viré par le Serveur.'+'°Ù#Æ]');
   end;
end;

procedure TChatRL.AnalysePremiereInformation(MessageRecu : string);
var
    i,j,k,NombreIdentifiant : integer;
    login,NomOrdi,MessageInfoArrive : string;
    Remplir,LoginExisteDejaDesole : boolean;
begin
     //EditLogin.Text + 'µ' + NomPcActuel + '«/\»' + NombreSecret
     Application.ProcessMessages;

     Login := Gauche('µ',MessageRecu);
     NomOrdi := Droite('µ',MessageRecu);
     NomOrdi := Gauche('«/\»',NomOrdi);
     NombreIdentifiant := StrToInt(Droite('«/\»',MessageRecu));
             
     Remplir := TRUE;
     LoginExisteDejaDesole := FALSE;

             for k := 0 to length(StructureOrdinateur)-1 do
             begin
                 if CompareStr(Login,StructureOrdinateur[k].LoginConnecte)=0 then
                 begin
                     LoginExisteDejaDesole := TRUE;
                 end;
             end;

             for j := 1 to NumeroArriveConnexion + 3 do
             begin
                if (StructureOrdinateur[j].LoginConnecte = '') and
                   (StructureOrdinateur[j].NomOrdinateur = '') and
                   (Remplir = TRUE) and (LoginExisteDejaDesole = FALSE) then
                begin
                   StructureOrdinateur[j].LoginConnecte := login;
                   StructureOrdinateur[j].NomOrdinateur :=  NomOrdi;
                   StructureOrdinateur[j].Iden := NombreIdentifiant;
                   StructureOrdinateur[j].img := 'En ligne';
                   Remplir := FALSE;
                end;
             end;

             if not Remplir then
             begin

               MessageInfoArrive := '„²´Ù¿'+'“”•œ'+'Serveur'+' >>  '+login+' ('+NomOrdi+')'+' vient de se connecter.'+'°Ù#Æ]';
               for i:=0 to NumeroArriveConnexion-1 do
               begin
                  ServerSocket.Socket.Connections[i].SendText(#13+MessageInfoArrive);
               end;
             end;

             if LoginExisteDejaDesole then
                    PasLeDroitDeSeConnecter(login,NomOrdi,NombreIdentifiant);
end;

Procedure TChatRL.PasLeDroitDeSeConnecter(Login : string; Ordi : string; iden : integer);
var
   MessageInfoDepart : string;
   i : integer;
begin
   MessageInfoDepart := 'TuEsViré°£°'+Login+'µ'+Ordi+'«/\»'+inttostr(iden)+'001';

   for i:=0 to NumeroArriveConnexion-1 do
   begin
      ServerSocket.Socket.Connections[i].SendText(#13+MessageInfoDepart);
   end;
end;


procedure TChatRL.AnalyseDerniereInformation(MessageRecu : string);
var
    j,k,l,UnCranDeMoins,Identifiant : integer;
    login,NomOrdi : string;
begin
     Application.ProcessMessages;
     Login := Gauche('µ',MessageRecu);
     MessageRecu := Droite('µ',MessageRecu);
     NomOrdi := Gauche('«/\»',MessageRecu);
     Identifiant := strtoint(Droite('«/\»',MessageRecu));

         for j:=1 to 52 do
         begin
             if (CompareStr(StructureOrdinateur[j].LoginConnecte, Login)=0)
                and (CompareStr(StructureOrdinateur[j].NomOrdinateur, NomOrdi)=0)
                and (Identifiant = StructureOrdinateur[j].Iden) then
             begin
                StructureOrdinateur[j].LoginConnecte := '';
                StructureOrdinateur[j].NomOrdinateur := '';
                StructureOrdinateur[j].Iden := 0;
                 StructureOrdinateur[j].Img := 'En ligne';

                fillchar(StructureOrdinateur002,sizeof(StructureOrdinateur002),0); // mettre la structure à zero
                UnCranDeMoins :=0;

                for k :=1 to 52 do
                begin
                     if (StructureOrdinateur[k].LoginConnecte = '')
                     and (StructureOrdinateur[k].NomOrdinateur ='')
                     and (StructureOrdinateur[k].Iden = 0)  then
                     begin
                         inc(UnCranDeMoins);
                     end
                     else
                     begin
                          StructureOrdinateur002[k-UnCranDeMoins].LoginConnecte := StructureOrdinateur[k].LoginConnecte;
                          StructureOrdinateur002[k-UnCranDeMoins].NomOrdinateur := StructureOrdinateur[k].NomOrdinateur;
                          StructureOrdinateur002[k-UnCranDeMoins].Iden := StructureOrdinateur[k].Iden;
                          StructureOrdinateur002[k-UnCranDeMoins].img := StructureOrdinateur[k].img;
                     end;
                end;

                fillchar(StructureOrdinateur,sizeof(StructureOrdinateur),0);
                for l :=1 to 52 do
                begin
                    if (StructureOrdinateur002[l].LoginConnecte <> '')
                       and (StructureOrdinateur002[l].NomOrdinateur <>'')
                       and (StructureOrdinateur002[l].Iden <> 0) then
                    begin
                         StructureOrdinateur[l].LoginConnecte := StructureOrdinateur002[l].LoginConnecte;
                         StructureOrdinateur[l].NomOrdinateur := StructureOrdinateur002[l].NomOrdinateur;
                         StructureOrdinateur[l].Iden := StructureOrdinateur002[l].Iden;
                         StructureOrdinateur[l].img := StructureOrdinateur002[l].img;
                    end;
                end;
             end;
         end;
end;


procedure TChatRL.TimerInformationsChateurTimer(Sender: TObject);
var
   i : integer;
begin
     {permet d'envoyer le message à tous le pc client connectés au serveur}
     for i:=0 to NumeroArriveConnexion-1 do
     begin
        ServerSocket.Socket.Connections[i].SendText(#13+MessageInfo);  // envoie vers le client
     end;
end;

function TChatRL.MessageInfo : string;
var
    i : integer;
    MessageInfoListeChateur,MessageInfoListeChateur1 : string;
begin
     Application.ProcessMessages;
     MessageInfoListeChateur1 := '';
     MessageInfoListeChateur := '';
     MessageInfoListeChateur := '@ù*@';
     for i:=1 to NumeroArriveConnexion + 3 do
     begin
        if StructureOrdinateur[i].LoginConnecte <> '' then
        begin
            MessageInfoListeChateur1 := MessageInfoListeChateur1 + 'µ'
            + StructureOrdinateur[i].LoginConnecte + '#IMG#' +  StructureOrdinateur[i].img +
            '#ORDI#'+StructureOrdinateur[i].NomOrdinateur;
        end;
     end;

     if MessageInfoListeChateur1 <> '' then
     begin
       MessageInfoListeChateur := MessageInfoListeChateur + MessageInfoListeChateur1 + 'µ¤@*!@¤';
       result:= MessageInfoListeChateur;
     end
     else
     begin
         result:= '??';
     end;

end;

procedure TChatRL.NomClientParti;
var
   i : integer;
   MessageInfoDepart : string;
begin
     MessageInfoDepart := 'º½»';
     for i:=0 to NumeroArriveConnexion-1 do
     begin
        ServerSocket.Socket.Connections[i].SendText(#13+MessageInfoDepart);  // envoie vers le client
     end;
end;

{Gérer le changement d'onglet}
procedure TChatRL.PageControlChanging(Sender: TObject;
  var AllowChange: Boolean);
begin
  if ((Sender as TPageControl).ActivePage = TabSheetServeur) and (ServeurActif = TRUE) then
     AllowChange := FALSE
end;

procedure TChatRL.LabeledEdit1KeyPress(Sender: TObject; var Key: Char);
var
  i : integer;
  MessageAEnvoyer : string;
begin
        if (Key = #13) and (ServeurActif = TRUE) then
        begin
           key := #0;
           for i:=0 to NumeroArriveConnexion-1 do
           begin
             ServerSocket.Socket.Connections[i].SendText(#13+'„²´Ù¿'+'Serveur'+' >>  '+MessageAEnvoyer+'°Ù#Æ]');  // envoie vers le client
           end;
        end;
        if (Key = #13) then
               key := #0;
end;

procedure TChatRL.Fermer1Click(Sender: TObject);
var
   i : integer;
begin
  ClipCursor(nil); // Annule la limitation du déplacement de la souris.
  if (not ClientConnecter) and (not ServeurActif) then
       Application.Terminate;

  if ServeurActif = TRUE then
  begin
    TimerNombresClientsActuels.Enabled := FALSE;
    TimerNombresClientsActuels.Interval := 100;
    for i:=0 to NumeroArriveConnexion-1 do
    begin
        ServerSocket.Socket.Connections[i].SendText(#13+'×»ûíç');  // envoie vers le client
    end;
    ServerSocket.Active := FALSE;
    Application.Terminate;
  end;

end;


{Gestion de la musique}
initialization
  NumeroArriveConnexion :=0;

end.


