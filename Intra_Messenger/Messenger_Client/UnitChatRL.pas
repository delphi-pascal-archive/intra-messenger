unit UnitChatRL;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, WinSock, Buttons, ScktComp, ExtCtrls, Grids,
  ValEdit, Menus, Math, ShellAPI, cxControls, cxSplitter, cxStyles,
  cxCustomData, cxGraphics, cxFilter, cxData, cxDataStorage, cxEdit, cxImage,
  cxGridCustomTableView, cxGridTableView, cxGridCustomView, cxClasses,
  cxGridLevel, cxGrid, cxBlobEdit, ImgList, cxTextEdit, cxGridBandedTableView,
  DB, DBClient, dxGDIPlusClasses, cxDBData, cxGridDBTableView, cxImageComboBox,
  ActnList, XPStyleActnCtrls, ActnMan, cxLookAndFeels, cxLookAndFeelPainters, Registry,
  WinSkinData, WinSkinStore, dxBar;

const
  WM_CAllBack = WM_USER;
  WM_MYMESSAGE = WM_USER + 100;

type
  TChatRL = class(TForm)
    ClientSocket: TClientSocket;
    MemoChat: TMemo;
    cxSplitter1: TcxSplitter;
    ImageListold: TImageList;
    ClientDataSet1: TClientDataSet;
    ClientDataSet1N_ID: TIntegerField;
    ClientDataSet1IMAGE: TGraphicField;
    ClientDataSet1NOMPRENOM: TStringField;
    DS_SOURCE: TDataSource;
    ActionManager1: TActionManager;
    ActionAjouterGroupe: TAction;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    IMG_LIGNE: TImage;
    IMG_OCCUPE: TImage;
    IMG_PAUSE: TImage;
    ClientDataSet3: TClientDataSet;
    DS_GROUPE: TDataSource;
    ClientDataSet3N_ID: TIntegerField;
    ClientDataSet3GROUPE: TStringField;
    ClientDataSet1N_GROUPE: TIntegerField;
    Panel2: TPanel;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    ComboBox1: TComboBox;
    IMG_1MN: TImage;
    IMG_TEL: TImage;
    IMG_ABS: TImage;
    ActionEMAIL: TAction;
    traymenu: TPopupMenu;
    Image1: TImage;
    SpeedButton4: TSpeedButton;
    ActionNavigateur: TAction;
    NavigateurWeb1: TMenuItem;
    BoitederceptionMail1: TMenuItem;
    N1: TMenuItem;
    ActionQuitter: TAction;
    Quitter1: TMenuItem;
    Statut1: TMenuItem;
    EnLigne1: TMenuItem;
    Occup1: TMenuItem;
    Autlphone1: TMenuItem;
    EnPause1: TMenuItem;
    Abs1mn1: TMenuItem;
    Absent1: TMenuItem;
    ClientDataSet1ORDI: TStringField;
    SkinStore1: TSkinStore;
    sd1: TSkinData;
    Action1: TAction;
    ActionFermer: TAction;
    Action4: TAction;
    Action5: TAction;
    Action6: TAction;
    Action7: TAction;
    Action8: TAction;
    Action9: TAction;
    Action10: TAction;
    Action11: TAction;
    Action12: TAction;
    Action13: TAction;
    dxBarManager1: TdxBarManager;
    dxBarManager1Bar1: TdxBar;
    dxBarSubItem1: TdxBarSubItem;
    dxBarSubItem2: TdxBarSubItem;
    dxBarSubItem3: TdxBarSubItem;
    dxBarSubItem4: TdxBarSubItem;
    dxBarSubItem5: TdxBarSubItem;
    dxBarButton1: TdxBarButton;
    dxBarButton2: TdxBarButton;
    dxBarButton3: TdxBarButton;
    dxBarButton4: TdxBarButton;
    dxBarSubItem6: TdxBarSubItem;
    dxBarSubItem7: TdxBarSubItem;
    dxBarButton5: TdxBarButton;
    dxBarButton6: TdxBarButton;
    dxBarButton7: TdxBarButton;
    dxBarButton8: TdxBarButton;
    dxBarButton9: TdxBarButton;
    dxBarButton10: TdxBarButton;
    dxBarButton11: TdxBarButton;
    dxBarButton12: TdxBarButton;
    dxBarButton13: TdxBarButton;
    dxBarButton14: TdxBarButton;
    TimerReconnexion: TTimer;
    cxGrid3DBTableView1: TcxGridDBTableView;
    cxGrid3Level1: TcxGridLevel;
    cxGrid3: TcxGrid;
    cxGrid3Level2: TcxGridLevel;
    cxGrid3DBTableView2: TcxGridDBTableView;
    cxGrid3DBTableView2N_ID: TcxGridDBColumn;
    cxGrid3DBTableView2GROUPE: TcxGridDBColumn;
    cxGrid3DBTableView1N_ID: TcxGridDBColumn;
    cxGrid3DBTableView1NOMPRENOM: TcxGridDBColumn;
    cxGrid3DBTableView1N_GROUPE: TcxGridDBColumn;
    cxGrid3DBTableView1ORDI: TcxGridDBColumn;
    cxGrid3DBTableView1IMAGE: TcxGridDBColumn;
    ImageList1: TImageList;
    procedure WM_CALLBACKPRO(var msg: TMessage); message wm_callBack;
    procedure mvtFenetre(i: Integer);
    function NomPcActuel: string;
    function MessageInfo: string;
    procedure FormCreate(Sender: TObject);
    procedure TimerNombresClientsActuelsTimer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure ClientSocketConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure AnalysePremiereInformation(MessageRecu: string);
    procedure AnalyseDerniereInformation(MessageRecu: string);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure LabeledEditMessageEcritKeyPress(Sender: TObject;
      var Key: Char);
    procedure Fermer1Click(Sender: TObject);
    procedure RendreVisiblePremierPlan;
    procedure PourquoiDeconnecte(raison: string; iden: integer);

    procedure DireQueOnSeDeconnecte;
    procedure BitBtnDeconnexionClick(Sender: TObject);
    procedure FormResize(Sender: TObject);

    procedure Minimize(Sender: TObject);

    procedure AnalyseMessageRecuParClient(Msg: string);
    procedure ActionAjouterGroupeExecute(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure ActionEMAILExecute(Sender: TObject);
    procedure ActionNavigateurExecute(Sender: TObject);
    procedure ActionQuitterExecute(Sender: TObject);
    procedure EnLigne1Click(Sender: TObject);
    procedure Action13Execute(Sender: TObject);
    procedure Action14Execute(Sender: TObject);
    procedure ActionFermerExecute(Sender: TObject);
    procedure Action10Execute(Sender: TObject);
    procedure TimerReconnexionTimer(Sender: TObject);
    procedure cxGrid3DBTableView1CellDblClick(Sender: TcxCustomGridTableView;
      ACellViewInfo: TcxGridTableDataCellViewInfo; AButton: TMouseButton;
      AShift: TShiftState; var AHandled: Boolean);

  private

  public

  end;

type
  TStructureListeConnecte = record
    LoginConnecte: string[30];
    NomOrdinateur: string[30];
    Iden: integer;
    img: string;
  end;

var
  Affichage: Boolean = False;
  root, path: string;
  ChatRL: TChatRL;
  EditIPConnexion, EditPortClient, EditLogin: string;
  StructureOrdinateur, StructureOrdinateur002: array[1..52] of TStructureListeConnecte;
  mvt, GroupeNB, NumeroArriveConnexion, NombresMaximumClients, NombreSecret: integer;
  ServeurActif, ClientConnecter: boolean;
  Present: TDateTime;
  Hour, Min, Sec, MSec: Word;
  nbpersonne, ChatHauteurDeDebut, ChatLargeurDeDebut, PageHauteurDebut, PageLargeurDebut: integer;
  TrayIcon: TNotifyIconData;
  blah: HICON;


function UserName(): string;


implementation

uses ChoixCouleurPanel, Unit_MsgPerso, AlertMsg, AudioVideo;

{$R *.dfm}

function QuelHeureEstIl: string;
begin
  Present := Now;
  DecodeTime(Present, Hour, Min, Sec, MSec);
  result := '[' + IntToStr(Hour) + ':' + IntToStr(Min) + ':' + IntToStr(Sec) + ']';
end;

function droite(substr: string; s: string): string;
begin
  if pos(substr, s) = 0 then result := '' else
    result := copy(s, pos(substr, s) + length(substr), length(s) - pos(substr, s) + length(substr));
end;

function gauche(substr: string; s: string): string;
begin
  result := copy(s, 1, pos(substr, s) - 1);
end;

procedure TChatRL.RendreVisiblePremierPlan;
begin
  if (ChoixCouleur.RadioGroupVisible.ItemIndex = 0) then
  begin
    Application.Restore;
    Application.BringToFront;
  end;
end;

function TChatRL.NomPcActuel: string;
var
  Buffer: array[0..255] of char;
  BufferSize: DWORD;
begin
  BufferSize := sizeOf(Buffer);
  GetComputerName(@buffer, BufferSize);
  result := buffer;
end;


procedure TChatRL.Minimize;
begin
  mvtFenetre(1);
  ChatRL.Visible := False;
end;

procedure TChatRL.FormCreate(Sender: TObject);
var
  Registre: TRegistry;
  SysMenu: hMenu;
  IPServeur: string;
  I: Integer;
begin
 // Application.OnMinimize := Minimize;
  root := ExtractFilePath(ParamStr(0));
  path := root + 'vsskin\';

  Registre := TRegistry.Create;
  Registre.RootKey := HKEY_LOCAL_MACHINE;

  Registre.OpenKey('\Software\IntraMSN\Couleur\', True);
  if Registre.ValueExists('Couleur') then
    sd1.SkinFile := Registre.ReadString('Couleur');

  Registre.OpenKey('\Software\IntraMSN\Image\', True);
  if (Registre.ValueExists('Image')) then
    ClientDataSet1IMAGE.DisplayWidth := Round(Registre.ReadInteger('Image') / 6);

  Registre.CloseKey;
  Registre.Free;

  ClientDataSet1.CreateDataSet;
  GroupeNB := 1;
  EditIPConnexion := '10.1.1.27';
  EditPortClient := '2879';
  ComboBox1.Text := 'En ligne';
  SysMenu := GetSystemMenu(Handle, False);
  ModifyMenu(SysMenu, sc_Close, mf_ByCommand, sc_Close, '&Quitter !!!'#9'Alt+F4');
  SysMenu := GetSystemMenu(application.handle, false);
  ModifyMenu(SysMenu, sc_Close, mf_ByCommand, sc_Close, '&Quitter !!!'#9'Alt+F4');
  ChatRL.Height := Round(500 * (Screen.Width / 1024) / 1.3);
  ChatRL.Width := Round(300 * (Screen.height / 768) / 1.3);
  ChatHauteurDeDebut := ChatRL.Height;
  ChatLargeurDeDebut := ChatRL.Width;
  ChoixCouleur := TChoixCouleur.Create(ChatRL);
  CAudioVideo := TCAudioVideo.Create(ChatRL);
  Randomize;
  NombreSecret := RandomRange(1000, 9999);
  ChatRL.Left := screen.Width - ChatRL.Width;
  ChatRL.top := screen.height - ChatRL.height - 30;
  blah := application.Icon.Handle;
  Trayicon.cbSize := SizeOf(TNotifyIconData);
  Trayicon.Wnd := handle;
  Trayicon.szTip := 'eMessenger';
  Trayicon.uID := 1;
  TrayIcon.hIcon := blah;
  TrayIcon.uCallbackMessage := WM_CAllBack;
  Trayicon.uFlags := NIF_MESSAGE or NIF_ICON or NIF_TIP;
  Shell_NotifyIcon(NIM_ADD, @trayicon);

  
  mvtFenetre(1);
  ChatRL.Visible := true;
  mvtFenetre(-1);
   ChatRL.Paint;

  EditLogin := UserName();

  if (EditIPConnexion <> '') and (EditPortClient <> '') and
    ((strtoint(EditPortClient)) > 0) then
  begin
    IPServeur := EditIPConnexion;
    ClientSocket.Host := IPServeur;
    ClientSocket.Port := strtoint(EditPortClient);
    ClientSocket.Active := TRUE;
  end;

  ClientDataSet3.Insert;
  ClientDataSet3N_ID.Value := 1;
  ClientDataSet3GROUPE.Value := 'Général';
  ClientDataSet3.Post;
end;

procedure TChatRL.WM_CALLBACKPRO(var msg: TMessage);
begin

  case msg.LParam of WM_LBUTTONDOWN:
      begin
        if ChatRL.Visible = true then
        begin
          mvtFenetre(1);
          ChatRL.Visible := False;
        end
        else
        begin
          mvt := 1;
          ChatRL.Visible := True;
          mvtFenetre(-1);
        end;
      end;
    WM_RBUTTONDOWN: traymenu.Popup(mouse.CursorPos.X, mouse.CursorPos.y);
  end;
end;

procedure TChatRL.mvtFenetre(i: Integer);
var
  k, fin, offset: integer;
begin
  offset := screen.Height - GetSystemMetrics(SM_CYFULLSCREEN);
  mvt := 1;
  ChatRL.Left := screen.Width - ChatRL.Width;
  if (i < 0) then
    fin := screen.Height - ChatRL.Height - offset
  else
    fin := screen.Height;
  while (ChatRL.Top <> fin) do
  begin
    ChatRL.Top := ChatRL.Top + i;
    for k := 1 to 1000000 do
      mvt := 1;
  end;
  if (i < 0) then
    ChatRL.Top := screen.Height - ChatRL.Height - offset
  else
    ChatRL.Top := screen.Height;
  mvt := 0;
end;

function UserName(): string;
const
  cnMaxUserNameLen = 254;
var
  UserName2: string;
  nSize: DWord;
begin
  nSize := cnMaxUserNameLen - 1;
  SetLength(UserName2, cnMaxUserNameLen);
  GetUserName(Pchar(UserName2), nSize);
  SetLength(UserName2, nSize - 1);
  result := UserName2;
end;

procedure TChatRL.TimerNombresClientsActuelsTimer(Sender: TObject);
begin
  application.ProcessMessages;
end;

procedure TChatRL.TimerReconnexionTimer(Sender: TObject);
var
  IPServeur: string;
begin
  if not ClientConnecter then
  begin
    if (EditIPConnexion <> '') and (EditPortClient <> '') and
      ((strtoint(EditPortClient)) > 0) then
    begin
      IPServeur := EditIPConnexion;
      ClientSocket.Host := IPServeur;
      ClientSocket.Port := strtoint(EditPortClient);
      ClientSocket.Active := TRUE;
      ClientConnecter := True;
    end;
  end
end;

procedure TChatRL.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ActionFermerExecute(Sender);
end;

procedure TChatRL.ClientSocketConnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  MessageInitial: string;
begin
  Application.ProcessMessages;
  ClientConnecter := TRUE;
  MessageInitial := 'µ' + EditLogin + 'µ' + NomPcActuel + '«/\»' + inttostr(NombreSecret) + '÷';
  ClientSocket.Socket.SendText(#13 + MessageInitial);
  Application.ProcessMessages;
end;

procedure TChatRL.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Application.ProcessMessages;
end;

procedure TChatRL.ClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent;
  var ErrorCode: Integer);
begin
  Application.ProcessMessages;
  ErrorCode := 0;
  Application.ProcessMessages;
  ClientSocket.Active := FALSE;
  ClientSocket.Close;
  ClientConnecter := FALSE;
end;

procedure TChatRL.AnalysePremiereInformation(MessageRecu: string);
var
  j, k, NombreIdentifiant: integer;
  login, NomOrdi: string;
  Remplir, LoginExisteDejaDesole: boolean;
begin
  Application.ProcessMessages;

  Login := Gauche('µ', MessageRecu);
  NomOrdi := Droite('µ', MessageRecu);
  NomOrdi := Gauche('«/\»', NomOrdi);
  NombreIdentifiant := StrToInt(Droite('«/\»', MessageRecu));

  Remplir := TRUE;
  LoginExisteDejaDesole := FALSE;

  for k := 0 to length(StructureOrdinateur) - 1 do
  begin
    if CompareStr(Login, StructureOrdinateur[k].LoginConnecte) = 0 then
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
      StructureOrdinateur[j].NomOrdinateur := NomOrdi;
      StructureOrdinateur[j].Iden := NombreIdentifiant;
      StructureOrdinateur[j].Img := ComboBox1.Text;
      Remplir := FALSE;
    end;
  end;
end;

procedure TChatRL.Action10Execute(Sender: TObject);
begin
  CAudioVideo.Show;
end;

procedure TChatRL.Action13Execute(Sender: TObject);
begin
  ChoixCouleur.Show;
end;

procedure TChatRL.Action14Execute(Sender: TObject);
var
  IPServeur: string;
begin
  if (EditIPConnexion <> '') and (EditPortClient <> '') and
    ((strtoint(EditPortClient)) > 0) then
  begin
    IPServeur := EditIPConnexion;
    ClientSocket.Host := IPServeur;
    ClientSocket.Port := strtoint(EditPortClient);
    ClientSocket.Active := TRUE;
  end;
end;

procedure TChatRL.ActionFermerExecute(Sender: TObject);
begin
  Shell_NotifyIcon(Nim_DELETE, @trayicon);
  Fermer1Click(ChatRL);
end;

procedure TChatRL.ActionAjouterGroupeExecute(Sender: TObject);
begin
  ClientDataSet3.Insert;
  GroupeNB := GroupeNB + 1;
  ClientDataSet3N_ID.Value := GroupeNB;
  ClientDataSet3GROUPE.Value := 'Groupe Temp';
  ClientDataSet3.Post;
end;

procedure TChatRL.ActionEMAILExecute(Sender: TObject);
begin
  if FileExists('C:\Program Files\Mozilla Thunderbird\thunderbird.exe') then
    ShellExecute(handle, 'open', 'C:\Program Files\Mozilla Thunderbird\thunderbird.exe', '', '', 0);
end;

procedure TChatRL.ActionNavigateurExecute(Sender: TObject);
begin
  if FileExists('C:\Program Files\Mozilla Firefox\firefox.exe') then
    ShellExecute(handle, 'open', 'C:\Program Files\Mozilla Firefox\firefox.exe', '', '', 0)
  else
    ShellExecute(handle, 'open', 'C:\Program Files\Internet Explorer\iexplorer.exe', '', '', 0);
end;

procedure TChatRL.ActionQuitterExecute(Sender: TObject);
begin
  Shell_NotifyIcon(Nim_DELETE, @trayicon);
  Fermer1Click(ChatRL);
end;

procedure TChatRL.AnalyseDerniereInformation(MessageRecu: string);
var
  j, k, l, UnCranDeMoins, Identifiant: integer;
  login, NomOrdi: string;
begin
  Application.ProcessMessages;
  Login := Gauche('µ', MessageRecu);
  MessageRecu := Droite('µ', MessageRecu);
  NomOrdi := Gauche('«/\»', MessageRecu);
  Identifiant := strtoint(Droite('«/\»', MessageRecu));

  for j := 1 to 52 do
  begin
    if (CompareStr(StructureOrdinateur[j].LoginConnecte, Login) = 0)
      and (CompareStr(StructureOrdinateur[j].NomOrdinateur, NomOrdi) = 0)
      and (Identifiant = StructureOrdinateur[j].Iden) then
    begin
      StructureOrdinateur[j].LoginConnecte := '';
      StructureOrdinateur[j].NomOrdinateur := '';
      StructureOrdinateur[j].Iden := 0;
      StructureOrdinateur[j].Img := ComboBox1.Text;

      fillchar(StructureOrdinateur002, sizeof(StructureOrdinateur002), 0); // mettre la structure à zero
      UnCranDeMoins := 0;

      for k := 1 to 52 do
      begin
        if (StructureOrdinateur[k].LoginConnecte = '')
          and (StructureOrdinateur[k].NomOrdinateur = '')
          and (StructureOrdinateur[k].Iden = 0) then
        begin
          inc(UnCranDeMoins);
        end
        else
        begin
          StructureOrdinateur002[k - UnCranDeMoins].LoginConnecte := StructureOrdinateur[k].LoginConnecte;
          StructureOrdinateur002[k - UnCranDeMoins].NomOrdinateur := StructureOrdinateur[k].NomOrdinateur;
          StructureOrdinateur002[k - UnCranDeMoins].Iden := StructureOrdinateur[k].Iden;
          StructureOrdinateur002[k - UnCranDeMoins].Img := StructureOrdinateur[k].Img;
        end;
      end;

      fillchar(StructureOrdinateur, sizeof(StructureOrdinateur), 0);
      for l := 1 to 52 do
      begin
        if (StructureOrdinateur002[l].LoginConnecte <> '')
          and (StructureOrdinateur002[l].NomOrdinateur <> '')
          and (StructureOrdinateur002[l].Iden <> 0) then
        begin
          StructureOrdinateur[l].LoginConnecte := StructureOrdinateur002[l].LoginConnecte;
          StructureOrdinateur[l].NomOrdinateur := StructureOrdinateur002[l].NomOrdinateur;
          StructureOrdinateur[l].Iden := StructureOrdinateur002[l].Iden;
          StructureOrdinateur[l].Img := StructureOrdinateur002[l].Img;
        end;
      end;
    end;
  end;
end;

procedure TChatRL.ComboBox1Change(Sender: TObject);
var
  j: integer;
  MessageStatut: string;
  Icon: TIcon;
  Image : TBitmap;
begin
  Icon := TIcon.Create;
  Image1.Picture := nil;
  ImageList1.GetIcon(ComboBox1.ItemIndex, Icon);
  ImageList1.GetBitmap(ComboBox1.ItemIndex,Image1.Picture.Bitmap);
  Trayicon.hIcon := Icon.Handle;
  Shell_NotifyIcon(Nim_Modify, @Trayicon);

      for j := 1 to 52 do
      begin
        if StructureOrdinateur[j].LoginConnecte = UserName then
          StructureOrdinateur[j].img := ComboBox1.Text;
      end;

      if ClientConnecter = TRUE then
      begin
        MessageStatut := '#STATUT#' + ComboBox1.Text + '#DE#' + EditLogin + '#FIN#';
        ChatRL.ClientSocket.Socket.SendText(#13 + MessageStatut);
      end;
end;

procedure TChatRL.cxGrid3DBTableView1CellDblClick(
  Sender: TcxCustomGridTableView; ACellViewInfo: TcxGridTableDataCellViewInfo;
  AButton: TMouseButton; AShift: TShiftState; var AHandled: Boolean);
var
  Login: string;
begin
  if ((ACellViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('NOMPRENOM').Index] <> '')) then
  begin
    Login := ACellViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('NOMPRENOM').Index];
    if CompareStr(Login, EditLogin) <> 0 then
    begin
      if assigned(MsgPerso) then
      begin
        MsgPerso.Caption := 'Vous souhaitez envoyer un message privé à ' + Login + ' :';
        MsgPerso.Login.Caption := ACellViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('ORDI').Index];
        MsgPerso.LabeledEdit1.clear;
        MsgPerso.Show;
      end
      else
      begin
        MsgPerso := TMsgPerso.Create(ChatRL);
        MsgPerso.Caption := 'Vous souhaitez envoyer un message privé à ' + Login + ' :';
        MsgPerso.Login.Caption := ACellViewInfo.GridRecord.Values[TcxGridDBTableView(Sender).GetColumnByFieldName('ORDI').Index];
        MsgPerso.cxGroupBox2.Caption := '  A : ' + Login + '  ';
        MsgPerso.Show;
      end;
    end
    else
    begin
      MessageDlg('Personne ne peut s''envoyer un message personnel !', mtInformation, [mbOK], 0);
    end;
  end;
end;

function TChatRL.MessageInfo: string;
var
  i: integer;
  MessageInfoListeChateur, MessageInfoListeChateur1: string;
begin
  Application.ProcessMessages;
  MessageInfoListeChateur1 := '';
  MessageInfoListeChateur := '';
  MessageInfoListeChateur := '@ù*@';
  for i := 1 to NumeroArriveConnexion + 3 do
  begin
    if StructureOrdinateur[i].LoginConnecte <> '' then
    begin
      MessageInfoListeChateur1 := MessageInfoListeChateur1 + 'µ' + StructureOrdinateur[i].LoginConnecte
        + '#IMG#' + StructureOrdinateur[i].img + '#ORDI#' + StructureOrdinateur[i].NomOrdinateur;
    end;
  end;

  if MessageInfoListeChateur1 <> '' then
  begin
    MessageInfoListeChateur := MessageInfoListeChateur + MessageInfoListeChateur1 + 'µ¤@*!@¤';
    result := MessageInfoListeChateur;
  end
  else
  begin
    result := '??';
  end;
end;

procedure TChatRL.ClientSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  TEMPO: string;
begin
  Application.ProcessMessages;
  TEMPO := socket.ReceiveText;

  while (pos(#13, TEMPO) <> 0) do
  begin
    AnalyseMessageRecuParClient(gauche(#13, TEMPO));
    TEMPO := droite(#13, TEMPO);
  end;
  AnalyseMessageRecuParClient(TEMPO);
end;


procedure TChatRL.AnalyseMessageRecuParClient(Msg: string);
var
  MessageRecuClient, MsgTemp, LoginEnvoi, LoginRecoi, MessageTexte: string;
  j, k, l: integer;
  TableauLocal: array[1..52] of integer;
  Personnage, Ordi, Image: string;
  Ajouter, beep: Boolean;
  Registre: TRegistry;



  newlabel : TLabel;
begin
  beep := False;
  Registre := TRegistry.Create;
  Registre.RootKey := HKEY_LOCAL_MACHINE;
  Registre.OpenKey('\Software\IntraMSN\Couleur\', True);
  Registre.OpenKey('\Software\IntraMSN\Son\', True);
  if Registre.ValueExists('Son') then
    if Registre.ReadInteger('Son') = 1 then
      beep := True;
  MessageRecuClient := Msg;
  if (CompareStr(copy(MessageRecuClient, 1, 5), '@ù*@µ') = 0) and (CompareStr(copy(MessageRecuClient, length(MessageRecuClient) - 5, 6), '¤@*!@¤') = 0) then
  begin
    k := 0;
    fillchar(TableauLocal, sizeof(TableauLocal), 0);

    for j := 1 to length(MessageRecuClient) - 5 do
    begin
      if MessageRecuClient[j] = 'µ' then
      begin
        inc(k);
        TableauLocal[k] := j;
      end;
    end;

    if k <> 0 then
    begin
      for l := 1 to k - 1 do
      begin
        Personnage := copy(MessageRecuClient, TableauLocal[l] + 1, (TableauLocal[l + 1]) - TableauLocal[l] - 1);
        if (CompareStr(Personnage, '') <> 0) and (comparestr(Personnage, '¤@*!@¤@ù*@') <> 0) then
        begin
          Image := Gauche('#ORDI#', Droite('#IMG#', Personnage));
          Ordi := Droite('#ORDI#', Personnage);
          Personnage := Gauche('#IMG#', Personnage);

          Ajouter := TRUE;
          DS_SOURCE.DataSet.First;
          while not (DS_SOURCE.DataSet.Eof) do
          begin
            if comparestr(ClientDataSet1NOMPRENOM.Value, Personnage) = 0 then
            begin
              Ajouter := FALSE;
            end;
            DS_SOURCE.DataSet.Next;
          end;
          DS_SOURCE.DataSet.First;
          if Ajouter then
          begin
            DS_SOURCE.DataSet.Insert;
            nbpersonne := nbpersonne + 1;
            ClientDataSet1N_ID.Value := nbpersonne;
            if Image = 'En Pause' then ClientDataSet1IMAGE.Assign(IMG_PAUSE.Picture.Bitmap);
            if Image = 'En ligne' then ClientDataSet1IMAGE.Assign(IMG_LIGNE.Picture.Bitmap);
            if Image = 'Occupé' then ClientDataSet1IMAGE.Assign(IMG_OCCUPE.Picture.Bitmap);
            if Image = 'Au téléphone' then ClientDataSet1IMAGE.Assign(IMG_TEL.Picture.Bitmap);
            if Image = 'Abs 1mn' then ClientDataSet1IMAGE.Assign(IMG_1MN.Picture.Bitmap);
            if Image = 'Absent' then ClientDataSet1IMAGE.Assign(IMG_ABS.Picture.Bitmap);
            ClientDataSet1NOMPRENOM.Value := Personnage;
            ClientDataSet1ORDI.Value := Ordi;
            ClientDataSet1N_GROUPE.Value := 1;
            DS_SOURCE.DataSet.Post;
          end;
        end;
      end;
    end;
  end;

  if CompareStr(copy(MessageRecuClient, 1, 3), 'º½»') = 0 then
  begin
    cxGrid3DBTableView1.ClearItems;
    if length(MessageRecuClient) > 5 then
    begin
      MessageRecuClient := Droite('º½»', MessageRecuClient);
    end;
  end;

  if CompareStr(copy(MessageRecuClient, 1, 5), '„²´Ù¿') = 0 then
  begin
    if CompareStr(copy(MessageRecuClient, length(MessageRecuClient) - 4, 5), '°Ù#Æ]') = 0 then
    begin
      MessageRecuClient := Gauche('°Ù#Æ]', MessageRecuClient);
      MessageRecuClient := Droite('„²´Ù¿', MessageRecuClient);
      if beep then
        MessageBeep(MB_OK);
      RendreVisiblePremierPlan;

      if CompareStr(copy(MessageRecuClient, 1, 4), '“”•œ') = 0 then
      begin
        MessageRecuClient := Droite('“”•œ', MessageRecuClient);
        MsgTemp := Droite('>>', Gauche('vient de se connecter', MessageRecuClient));
        MsgTemp := MsgTemp + #13 + ' vient ' + #13 + ' de se connecter';
        AlertMsgBox('Connexion', MsgTemp, 0, false, 1000, 10, nil);
        MemoChat.Lines.Add(MessageRecuClient + '   ' + QuelHeureEstIl);
      end
      else
      begin
        AlertMsgBox('Déconnexion', MessageRecuClient, 0, false, 1000, 10, nil);
        MemoChat.Lines.Add(MessageRecuClient);
      end;
    end;
  end;

  if CompareStr(copy(MessageRecuClient, 1, 8), '#STATUT#') = 0 then
  begin
    MessageRecuClient := Gauche('#FIN#', MessageRecuClient);
    MessageRecuClient := Droite('#STATUT#', MessageRecuClient);
    LoginEnvoi := Droite('#DE#', MessageRecuClient);
    MessageRecuClient := Gauche('#DE#', MessageRecuClient);
    if beep then
      MessageBeep(MB_OK);
    RendreVisiblePremierPlan;

    DS_SOURCE.DataSet.First;
    while not DS_SOURCE.DataSet.Eof do
    begin
      if (ClientDataSet1NOMPRENOM.Value = LoginEnvoi) then
      begin
        ClientDataSet1.Edit;
        if MessageRecuClient = 'En Pause' then ClientDataSet1IMAGE.Assign(IMG_PAUSE.Picture.Bitmap);
        if MessageRecuClient = 'En ligne' then ClientDataSet1IMAGE.Assign(IMG_LIGNE.Picture.Bitmap);
        if MessageRecuClient = 'Occupé' then ClientDataSet1IMAGE.Assign(IMG_OCCUPE.Picture.Bitmap);
        if MessageRecuClient = 'Au téléphone' then ClientDataSet1IMAGE.Assign(IMG_TEL.Picture.Bitmap);
        if MessageRecuClient = 'Abs 1mn' then ClientDataSet1IMAGE.Assign(IMG_1MN.Picture.Bitmap);
        if MessageRecuClient = 'Absent' then ClientDataSet1IMAGE.Assign(IMG_ABS.Picture.Bitmap);
        ClientDataSet1.Post;
      end;
      DS_SOURCE.DataSet.Next;
    end;
  end;

  if CompareStr(copy(MessageRecuClient, 1, 8), 'MsgPrive') = 0 then
  begin
    MessageRecuClient := Gauche('#FIN#', MessageRecuClient);
    MessageRecuClient := Droite('MsgPrive#DE#', MessageRecuClient);
    LoginEnvoi := Gauche('#POUR#', MessageRecuClient);
    MessageRecuClient := Droite('#POUR#', MessageRecuClient);
    LoginRecoi := Gauche('#CORPS#', MessageRecuClient);

    if (Comparestr(LoginEnvoi, EditLogin) = 0) or (Comparestr(LoginRecoi, EditLogin) = 0) then
    begin
      MessageTexte := Droite('#CORPS#', MessageRecuClient);
      if beep then
        MessageBeep(MB_OK);
      RendreVisiblePremierPlan;
      if (MemoChat.Lines.Count > 10) then
        MemoChat.Lines.Clear;

      if (LoginEnvoi <> UserName) then
      begin
        if assigned(MsgPerso) then
        begin

          if (MsgPerso.Caption <> 'Vous souhaitez envoyer un message privé à ' + LoginEnvoi + ' :') then
          begin
            MsgPerso := TMsgPerso.Create(ChatRL);
            MsgPerso.Caption := 'Vous souhaitez envoyer un message privé à ' + LoginEnvoi + ' :';
            MsgPerso.cxGroupBox2.Caption := '  A : ' + LoginEnvoi + '  ';
            MsgPerso.Memo1.Lines.Add(LoginEnvoi + ' dit : ' + MessageTexte);
            MsgPerso.Show;
            FlashWindow(Application.Handle, true);
          end
          else
          begin
            MsgPerso.Memo1.Lines.Add(LoginEnvoi + ' dit : ' + MessageTexte);
            FlashWindow(Application.Handle, true);
          end;
        end
        else
        begin
          MsgPerso := TMsgPerso.Create(ChatRL);
          MsgPerso.Caption := 'Vous souhaitez envoyer un message privé à ' + LoginEnvoi + ' :';
          MsgPerso.cxGroupBox2.Caption := '  A : ' + LoginEnvoi + '  ';
          MsgPerso.Memo1.Lines.Add(LoginEnvoi + ' dit : ' + MessageTexte);
          MsgPerso.Show;
          FlashWindow(Application.Handle, true);
        end;
      end
      else
        MsgPerso.Memo1.Lines.Add(LoginEnvoi + ' dit : ' + MessageTexte);
    end;
  end;

  if CompareStr(copy(MessageRecuClient, 1, 12), 'MsgTransfert') = 0 then
  begin
    MessageRecuClient := Gauche('#FIN#', MessageRecuClient);
    MessageRecuClient := Droite('MsgTransfert#DE#', MessageRecuClient);
    LoginEnvoi := Gauche('#POUR#', MessageRecuClient);
    MessageRecuClient := Droite('#POUR#', MessageRecuClient);
    LoginRecoi := Gauche('#CORPS#', MessageRecuClient);

    if (Comparestr(LoginEnvoi, EditLogin) = 0) or (Comparestr(LoginRecoi, EditLogin) = 0) then
    begin
      MessageTexte := Droite('#CORPS#', MessageRecuClient);
      if beep then
        MessageBeep(MB_OK);
      RendreVisiblePremierPlan;
      if (MemoChat.Lines.Count > 10) then
        MemoChat.Lines.Clear;

      if (LoginEnvoi <> UserName) then
      begin
        if assigned(MsgPerso) then
        begin
          if (MsgPerso.Caption <> 'Vous souhaitez envoyer un message privé à ' + LoginEnvoi + ' :') then
          begin
            MsgPerso := TMsgPerso.Create(ChatRL);
            MsgPerso.Caption := 'Vous souhaitez envoyer un message privé à ' + LoginEnvoi + ' :';
            MsgPerso.cxGroupBox2.Caption := '  A : ' + LoginEnvoi + '  ';
            MsgPerso.Memo1.Lines.Add(LoginEnvoi + ' vous transmet un fichier : ' + MessageTexte);
            ////////////////




 newlabel := Tlabel.Create(MsgPerso.Memo1);
 with newlabel do
 begin
 Parent := MsgPerso.Memo1;
 Caption := 'testtt';
 end;



            MsgPerso.Memo1.Lines.InsertObject(0, 'Test', SpeedButton3);
            MsgPerso.Show;
            FlashWindow(Application.Handle, true);
          end
          else
          begin
            MsgPerso.Memo1.Lines.Add(LoginEnvoi + ' vous transmet un fichier : ' + MessageTexte);
            FlashWindow(Application.Handle, true);
          end;
        end
        else
        begin
          MsgPerso := TMsgPerso.Create(ChatRL);
          MsgPerso.Caption := 'Vous souhaitez envoyer un message privé à ' + LoginEnvoi + ' :';
          MsgPerso.cxGroupBox2.Caption := '  A : ' + LoginEnvoi + '  ';
          MsgPerso.Memo1.Lines.Add(LoginEnvoi + ' dit : ' + MessageTexte);
          MsgPerso.Show;
          FlashWindow(Application.Handle, true);
        end;
      end
      else
        MsgPerso.Memo1.Lines.Add('Vous avez proposer un transfert de fichier');
    end;
  end;

  if CompareStr(copy(MessageRecuClient, 1, 9), 'MsgBouger') = 0 then
  begin
    MessageRecuClient := Gauche('#FIN#', MessageRecuClient);
    MessageRecuClient := Droite('MsgBouger#DE#', MessageRecuClient);
    LoginEnvoi := Gauche('#POUR#', MessageRecuClient);
    MessageRecuClient := Droite('#POUR#', MessageRecuClient);
    LoginRecoi := Gauche('#CORPS#', MessageRecuClient);

    if (Comparestr(LoginEnvoi, EditLogin) = 0) or (Comparestr(LoginRecoi, EditLogin) = 0) then
    begin
      MessageTexte := Droite('#CORPS#', MessageRecuClient);
      if beep then
        MessageBeep(MB_OK);
      RendreVisiblePremierPlan;
      if (MemoChat.Lines.Count > 10) then
        MemoChat.Lines.Clear;

      if (LoginEnvoi <> UserName) then
      begin
        if assigned(MsgPerso) then
        begin
          if (MsgPerso.Caption <> 'Vous souhaitez envoyer un message privé à ' + LoginEnvoi + ' :') then
          begin
            MsgPerso := TMsgPerso.Create(ChatRL);
            MsgPerso.Caption := 'Vous souhaitez envoyer un message privé à ' + LoginEnvoi + ' :';
            MsgPerso.cxGroupBox2.Caption := '  A : ' + LoginEnvoi + '  ';
            MsgPerso.Memo1.Lines.Add(LoginEnvoi + ' ' + MessageTexte);
            MsgPerso.Show;
            Bouge := True;
            FlashWindow(Application.Handle, true);
          end
          else
          begin
            MsgPerso.Memo1.Lines.Add(LoginEnvoi + ' ' + MessageTexte);
            Bouge := True;
            FlashWindow(Application.Handle, true);
          end;
        end
        else
        begin
          MsgPerso := TMsgPerso.Create(ChatRL);
          MsgPerso.Caption := 'Vous souhaitez envoyer un message privé à ' + LoginEnvoi + ' :';
          MsgPerso.cxGroupBox2.Caption := '  A : ' + LoginEnvoi + '  ';
          MsgPerso.Memo1.Lines.Add(LoginEnvoi + ' ' + MessageTexte);
          MsgPerso.Show;
          Bouge := True;
          FlashWindow(Application.Handle, true);
        end;
      end
      else
        MsgPerso.Memo1.Lines.Add('Arrêtez de réveiller votre collègue !');
    end;
  end;

  if CompareStr(copy(MessageRecuClient, 1, 5), '×»ûíç') = 0 then
  begin
    MemoChat.Lines.Add('Le Serveur vient de se déconnecter...  ' + QuelHeureEstIl);
    Application.ProcessMessages;
    cxGrid3DBTableView1.ClearItems;

    ClientSocket.Active := FALSE;
    ClientSocket.Close;
    ClientConnecter := FALSE;
  end;
end;

procedure TChatRL.PourquoiDeconnecte(raison: string; iden: integer);
begin
  case StrToInt(raison) of
    001: begin
        MessageDlg('Votre login est déjà utilisé.', mtInformation, [mbOK], 0);
      end;
    003: begin
        MessageDlg('Le serveur est plein. Veuillez réessayer ultèrieurement.', mtInformation, [mbOK], 0);
      end;
  end;

  Application.ProcessMessages;

  cxGrid3DBTableView1.ClearItems;

  ClientSocket.Active := FALSE;
  ClientSocket.Close;
  ClientConnecter := FALSE;
end;

{Gérer le changement d'onglet}

procedure TChatRL.LabeledEditMessageEcritKeyPress(Sender: TObject;
  var Key: Char);
var
  DroitEcrire: boolean;
  MessageAEnvoyer: string;
begin
  if (Key = #13)
    and (ClientConnecter = TRUE) then
  begin
    key := #0;
    DroitEcrire := FALSE;
    DS_SOURCE.DataSet.First;

    while not DS_SOURCE.DataSet.Eof do
    begin
      if CompareStr(EditLogin, ClientDataSet1NOMPRENOM.Value) = 0 then
      begin
        DroitEcrire := TRUE;
      end;
      DS_SOURCE.DataSet.Next;
    end;
    if DroitEcrire then
    begin
      MessageAEnvoyer := 'äâã¥' + EditLogin + 'äâã¥ä¥@?';
      ClientSocket.Socket.SendText(#13 + MessageAEnvoyer);
    end;
  end;
  if (Key = #13) then
    key := #0;
end;

procedure TChatRL.Fermer1Click(Sender: TObject);
begin
  ClipCursor(nil);
  if (not ClientConnecter) then
    Application.Terminate;

  if ClientConnecter = TRUE then
  begin
    DireQueOnSeDeconnecte;
    ClientSocket.Active := FALSE;
    sleep(1000);
    Application.Terminate;
  end;

end;

procedure TChatRL.DireQueOnSeDeconnecte;
var
  MessageFinal: string;
begin
  Application.ProcessMessages;

  cxGrid3DBTableView1.ClearItems;

  if ClientConnecter then
  begin
    MessageFinal := '@DECO' + EditLogin + 'µ' + NomPcActuel + '«/\»' + inttostr(NombreSecret) + 'Ê';
    ClientSocket.Socket.SendText(#13 + MessageFinal);
  end;

  ClientSocket.Active := FALSE;
  ClientSocket.Close;
  ClientConnecter := FALSE;

end;

procedure TChatRL.EnLigne1Click(Sender: TObject);
var
  j: integer;
  MessageStatut: string;
  Icon: TIcon;
begin
  MessageStatut := (Sender as TMenuItem).Caption;
  Icon := TIcon.Create;
  DS_SOURCE.dataset.First;
  while not DS_SOURCE.DataSet.Eof do
  begin
    if UserName = ClientDataSet1NOMPRENOM.Value then
    begin
      ClientDataSet1.Edit;
      if MessageStatut = '&En Ligne' then
      begin
        ImageList1.GetIcon(0, Icon);
        Image1.Picture.Bitmap := IMG_LIGNE.Picture.Bitmap;
        ClientDataSet1IMAGE.Assign(IMG_LIGNE.Picture.Bitmap);
      end;
      if MessageStatut = '&Occupé' then
      begin
        ImageList1.GetIcon(1, Icon);
        Image1.Picture.Bitmap := IMG_OCCUPE.Picture.Bitmap;
        ClientDataSet1IMAGE.Assign(IMG_OCCUPE.Picture.Bitmap);
      end;
      if MessageStatut = '&Au téléphone' then
      begin
        ImageList1.GetIcon(2, Icon);
        Image1.Picture.Bitmap := IMG_TEL.Picture.Bitmap;
        ClientDataSet1IMAGE.Assign(IMG_TEL.Picture.Bitmap);
      end;
      if MessageStatut = 'E&n Pause' then
      begin
        ImageList1.GetIcon(3, Icon);
        Image1.Picture.Bitmap := IMG_PAUSE.Picture.Bitmap;
        ClientDataSet1IMAGE.Assign(IMG_PAUSE.Picture.Bitmap);
      end;
      if MessageStatut = 'A&bs 1mn' then
      begin
        ImageList1.GetIcon(4, Icon);
        Image1.Picture.Bitmap := IMG_1MN.Picture.Bitmap;
        ClientDataSet1IMAGE.Assign(IMG_1MN.Picture.Bitmap);
      end;
      if MessageStatut = 'Ab&sent' then
      begin
        ImageList1.GetIcon(5, Icon);
        Image1.Picture.Bitmap := IMG_ABS.Picture.Bitmap;
        ClientDataSet1IMAGE.Assign(IMG_ABS.Picture.Bitmap);
      end;
      ClientDataSet1.Post;
      Trayicon.hIcon := Icon.Handle;
      Shell_NotifyIcon(Nim_Modify, @Trayicon);

      for j := 1 to 52 do
      begin
        if StructureOrdinateur[j].LoginConnecte = UserName then
          StructureOrdinateur[j].img := ComboBox1.Text;
      end;

      if ClientConnecter = TRUE then
      begin
        MessageStatut := '#STATUT#' + ComboBox1.Text + '#DE#' + EditLogin + '#FIN#';
        ChatRL.ClientSocket.Socket.SendText(#13 + MessageStatut);
      end;
    end;
    DS_SOURCE.DataSet.Next;
  end;

end;

procedure TChatRL.BitBtnDeconnexionClick(Sender: TObject);
begin
  DireQueOnSeDeconnecte;
end;

procedure TChatRL.FormResize(Sender: TObject);
begin
  Application.OnMinimize := Minimize;
end;



initialization
  NumeroArriveConnexion := 0;

end.

