unit Unit_MsgPerso;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, cxControls, cxLookAndFeels, cxLookAndFeelPainters,
  cxContainer, cxEdit, IdAntiFreezeBase, IdAntiFreeze, IdCustomTCPServer,
  IdTCPServer, IdCmdTCPServer, IdExplicitTLSClientServerBase, IdFTPServer,
  IdUserAccounts, IdComponent, IdTCPConnection, IdTCPClient, IdFTP,
  IdBaseComponent, IdZLibCompressorBase, IdCompressorZLibEx, ExtCtrls,
  cxProgressBar, cxSplitter, StdCtrls, cxGroupBox, Buttons,
  IdFTPListOutput, Registry, IdFTPList, IdWinSock2 ;

type
  TMsgPerso = class(TForm)
    Panel1: TPanel;
    SpeedButton5: TSpeedButton;
    Login: TLabel;
    SpeedButton1: TSpeedButton;
    BitBtnEnvoyermsgPrive: TBitBtn;
    BitBtn1: TBitBtn;
    Panel2: TPanel;
    cxGroupBox1: TcxGroupBox;
    LabeledEdit1: TEdit;
    cxGroupBox2: TcxGroupBox;
    Memo1: TMemo;
    cxSplitter1: TcxSplitter;
    FontDialog1: TFontDialog;
    Ouvrir: TOpenDialog;
    TimerWizz: TTimer;
    IdCompressorZLibEx2: TIdCompressorZLibEx;
    IdFTP1: TIdFTP;
    IdUserManager1: TIdUserManager;
    IdFTPServer1: TIdFTPServer;
    IdAntiFreeze1: TIdAntiFreeze;
    Timer1: TTimer;
    Transfert: TPanel;
    cxProgressBar1: TcxProgressBar;
    Taux_Transfert: TLabel;
    Niveau_Transfert: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure IdFTPServer1StoreFile(ASender: TIdFTPServerContext;
      const AFileName: string; AAppend: Boolean; var VStream: TStream);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure SpeedButton5Click(Sender: TObject);
    procedure BitBtnEnvoyermsgPriveClick(Sender: TObject);
    procedure TimerWizzTimer(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure IdFTPServer1RetrieveFile(ASender: TIdFTPServerContext;
      const AFileName: string; var VStream: TStream);
    procedure IdFTPServer1RemoveDirectory(ASender: TIdFTPServerContext;
      var VDirectory: string);
    procedure IdFTPServer1MakeDirectory(ASender: TIdFTPServerContext;
      var VDirectory: string);
    procedure IdFTPServer1ListDirectory(ASender: TIdFTPServerContext;
      const APath: string; ADirectoryListing: TIdFTPListOutput; const ACmd,
      ASwitches: string);
    procedure IdFTPServer1GetFileSize(ASender: TIdFTPServerContext;
      const AFilename: string; var VFileSize: Int64);
    procedure IdFTPServer1DeleteFile(ASender: TIdFTPServerContext;
      const APathName: string);
    procedure IdFTPServer1ChangeDirectory(ASender: TIdFTPServerContext;
      var VDirectory: string);
    procedure IdFTP1Work(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Integer);
    procedure IdFTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Integer);
    procedure IdFTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure FontDialog1Apply(Sender: TObject; Wnd: HWND);
  private
    function ReplaceChars(APath: string): string;
    function GetSizeOfFile(AFile: string): Integer;
  public
    FileSize: integer;
    FileName: string;
    STime: extended;
    AbortTransfer: boolean;
  end;

var
  MsgPerso: TMsgPerso;
  Bouge: Boolean;
  cpt: integer = 0;
  AppDir: string;

implementation

uses IdFTPCommon, UnitChatRL;

{$R *.dfm}

var
  ServeurEnReception: Boolean = False;
  ServeurAdresseClient: string = '';
  ClientFichier: file;

function GaucheNDroite(substr: string; s: string; n: integer): string;
var i: integer;
begin
  S := S + substr;
  for i := 1 to n do
  begin
    S := copy(s, pos(substr, s) + length(substr), length(s) - pos(substr, s) + length(substr));
  end;
  result := copy(s, 1, pos(substr, s) - 1);
end;

function TrouverNomLoginQuiRecoitMsg: string;
var
  Login: string;
begin
  Login := MsgPerso.Caption;
  Login := GaucheNDroite(' ', Login, 7);
  result := Login;
end;


procedure TMsgPerso.FontDialog1Apply(Sender: TObject; Wnd: HWND);
begin
  //LabeledEdit1.Font := FontDialog1.Font;
end;

procedure TMsgPerso.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ServeurEnReception and
    (messagedlg('Etes vous sur de vouloir Fermer la fenêtre ?', mtconfirmation, [mbYes, mbNo], 0) = mrNo) then
  begin
     //rien a faire
  end
  else
  begin
    IdFTP1.Disconnect;
    MsgPerso.Destroy;
    MsgPerso := nil;
  end;
end;

function TMsgPerso.ReplaceChars(APath: string): string;
var
  s: string;
begin
  s := StringReplace(APath, '/', '\', [rfReplaceAll]);
  s := StringReplace(s, '\\', '\', [rfReplaceAll]);
  Result := s;
end;

procedure TMsgPerso.FormCreate(Sender: TObject);
var
  Registre: TRegistry;
  tmpCouleur: integer;
begin
  IdFTPServer1.Active := True;
  if IdFTP1.Connected then IdFTP1.Disconnect;
end;


function TMsgPerso.GetSizeOfFile(AFile: string): Integer;
var
  FStream: TFileStream;
begin
  try
    FStream := TFileStream.Create(AFile, fmOpenRead);
    try
      Result := FStream.Size;
    finally
      FreeAndNil(FStream);
    end;
  except
    Result := 0;
  end;
end;

procedure TMsgPerso.IdFTP1Work(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCount: Integer);
var
  S: string;
  TotalTime: TDateTime;
  H, M, Sec, MS: Word;
  DLTime: Double;
  AverageSpeed: extended;
begin
  Application.ProcessMessages;
  TotalTime := Now - STime;
  DecodeTime(TotalTime, H, M, Sec, MS);
  Sec := Sec + M * 60 + H * 3600;
  DLTime := Sec + MS / 1000;
  if DLTime > 0 then
  begin
    AverageSpeed := (AWorkCount / 1024) / DLTime;
    S := FormatFloat('0.00 Kb/s', AverageSpeed);
    Taux_Transfert.Caption := S;
  end;
 // if AbortTransfer then IdFTP1.Abort;
  cxProgressBar1.EditValue := AWorkCount/FileSize * 100;
  Niveau_Transfert.Caption := IntToStr(AWorkCount) + '/' + IntToStr(FileSize) + ' octets';
end;

procedure TMsgPerso.IdFTP1WorkBegin(ASender: TObject; AWorkMode: TWorkMode;
  AWorkCountMax: Integer);
begin
  ServeurEnReception := True;
  AbortTransfer := false;
  STime := Now;
  Memo1.Lines.Add(FileName);
  Taux_Transfert.Caption := '0.00 Kb/s';
  if FileSize < AWorkCountMax then FileSize := AWorkCountMax;
  Niveau_Transfert.Caption := '0 / ' + IntToStr(FileSize) + ' octets';
end;

procedure TMsgPerso.IdFTP1WorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  // SpeedButton2.Visible := false;
  //Memo1.Lines.Clear;
  //if AbortTransfer then Memo2.Lines.Add('Transfert Annulé : ' + FileName)
 // else
  if (FileName <> '') then Memo1.Lines.Add('Transfert Complet : ' + FileName);
  FileSize := 0;
  FileName := '';
  IdFTP1.Disconnect;
  ServeurEnReception := False;
end;

procedure TMsgPerso.IdFTPServer1ChangeDirectory(ASender: TIdFTPServerContext;
  var VDirectory: string);
begin
  ASender.CurrentDir := VDirectory;
end;

procedure TMsgPerso.IdFTPServer1DeleteFile(ASender: TIdFTPServerContext;
  const APathName: string);
begin
  DeleteFile(ReplaceChars(AppDir + ASender.CurrentDir + '\' + APathname));
end;

procedure TMsgPerso.IdFTPServer1GetFileSize(ASender: TIdFTPServerContext;
  const AFilename: string; var VFileSize: Int64);
var
  LFile: string;
begin
  LFile := ReplaceChars(AppDir + AFilename);
  try
    if FileExists(LFile) then
      VFileSize := GetSizeOfFile(LFile)
    else
      VFileSize := 0;
  except
    VFileSize := 0;
  end;
end;

procedure TMsgPerso.IdFTPServer1ListDirectory(ASender: TIdFTPServerContext;
  const APath: string; ADirectoryListing: TIdFTPListOutput; const ACmd,
  ASwitches: string);
var
  LFTPItem: TIdFTPListItem;
  SR: TSearchRec;
  SRI: Integer;
begin
  ADirectoryListing.DirFormat := doUnix;
  SRI := FindFirst(AppDir + APath + '\*.*', faAnyFile - faHidden - faSysFile, SR);
  while SRI = 0 do
  begin
    LFTPItem := ADirectoryListing.Add;
    LFTPItem.FileName := SR.Name;
    LFTPItem.Size := SR.Size;
    LFTPItem.ModifiedDate := FileDateToDateTime(SR.Time);
    if SR.Attr = faDirectory then
      LFTPItem.ItemType := ditDirectory
    else
      LFTPItem.ItemType := ditFile;
    SRI := FindNext(SR);
  end;
  FindClose(SR);
  SetCurrentDir(AppDir + APath + '\..');
end;

procedure TMsgPerso.IdFTPServer1MakeDirectory(ASender: TIdFTPServerContext;
  var VDirectory: string);
begin
  if not ForceDirectories(ReplaceChars(AppDir + VDirectory)) then
  begin
    raise Exception.Create('Unable to create directory');
  end;
end;

procedure TMsgPerso.IdFTPServer1RemoveDirectory(ASender: TIdFTPServerContext;
  var VDirectory: string);
var
  LFile: string;
begin
  LFile := ReplaceChars(AppDir + VDirectory);
end;

procedure TMsgPerso.IdFTPServer1RetrieveFile(ASender: TIdFTPServerContext;
  const AFileName: string; var VStream: TStream);
begin
  VStream := TFileStream.Create(ReplaceChars(AppDir + AFilename), fmOpenRead);
end;

procedure TMsgPerso.IdFTPServer1StoreFile(ASender: TIdFTPServerContext;
  const AFileName: string; AAppend: Boolean; var VStream: TStream);
begin
  if not Aappend then
    VStream := TFileStream.Create(ReplaceChars(AppDir + AFilename), fmCreate)
  else
    VStream := TFileStream.Create(ReplaceChars(AppDir + AFilename), fmOpenWrite)
end;


function TrouverIP(ordinateur: string): string;
var
  WSAData: TWSAData;
  Name, Address: string;
  Phe: PHostEnt;
begin
  WSAStartup(2, WSAData);
  SetLength(Name, 255);
  Phe := GetHostByName(PChar(ordinateur));
  with Phe^ do
    Address := Format('%d.%d.%d.%d', [Byte(h_addr^[0]), Byte(h_addr^[1]), Byte(h_addr^[2]), Byte(h_addr^[3])]);
  WSACleanup;
  TrouverIP := Address;
end;


procedure TMsgPerso.SpeedButton1Click(Sender: TObject);
var
  MessageBouger: string;
begin
  MessageBouger := 'MsgBouger' + '#DE#' + EditLogin + '#POUR#' + TrouverNomLoginQuiRecoitMsg + '#CORPS#vient de te réveiller ! :'')#FIN#';
    ChatRL.ClientSocket.Socket.SendText(#13 + MessageBouger);
  Bouge := True;
end;

procedure TMsgPerso.SpeedButton5Click(Sender: TObject);
var
  MessageTransfert: string;
begin
  if not Ouvrir.Execute then Exit;
  AssignFile(ClientFichier, Ouvrir.FileName);
  MessageTransfert := 'MsgTransfert' + '#DE#' + EditLogin + '#POUR#' + TrouverNomLoginQuiRecoitMsg + '#CORPS#' + ExtractFileName(Ouvrir.FileName) + '#FIN#';
  ChatRL.ClientSocket.Socket.SendText(#13 + MessageTransfert);
  if not IdFTP1.Connected then
  begin
    IdFTP1.Host := TrouverIP(Login.Caption);
    IdFTP1.UserName := 'root';
    IdFTP1.Password := '';
    IdFTP1.Connect;
  end;
  if (IdFTP1.Connected) then
  begin
    Transfert.Visible := True;
    IdFTP1.TransferType := ftBinary;
    IdFTP1.Put(Ouvrir.FileName, ExtractFileName(Ouvrir.FileName));
    Reset(ClientFichier, 1);
  end;
end;

procedure TMsgPerso.TimerWizzTimer(Sender: TObject);
begin
  if Bouge then
  begin
    if cpt = 10 then
    begin
      Bouge := False;
      cpt := 0;
    end
    else
    begin
      if (cpt mod 2) = 0 then
        MsgPerso.Left := MsgPerso.Left + 5
      else
        MsgPerso.Left := MsgPerso.Left - 5;
    end;
    cpt := cpt + 1;
  end;
  Exit;
end;

procedure TMsgPerso.BitBtn1Click(Sender: TObject);
begin
  if (FontDialog1.Execute) then
  begin
    LabeledEdit1.Font := FontDialog1.Font;
    Memo1.Font := FontDialog1.Font;
  end;
end;


procedure TMsgPerso.BitBtnEnvoyermsgPriveClick(Sender: TObject);
var
  MessagePrive: string;
begin
  if LabeledEdit1.Text <> '' then
  begin
    if ClientConnecter = TRUE then
    begin
      MessagePrive := 'MsgPrive' + '#DE#' + EditLogin + '#POUR#' + TrouverNomLoginQuiRecoitMsg + '#CORPS#' + LabeledEdit1.Text + '#FIN#';
      ChatRL.ClientSocket.Socket.SendText(#13 + MessagePrive);
    end;
  end;
  LabeledEdit1.Clear;
end;


end.

